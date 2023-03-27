from __future__ import annotations
from dataclasses import dataclass, field
from enum import Enum, StrEnum, auto
from pprint import pprint
import random
from typing import NoReturn, Optional, Sequence

from pylenium.config import PyleniumConfig
from pylenium.driver import Pylenium
from pylenium.element import Element
import selenium.common.exceptions


BASE_URL = "http://localhost:8000/Src/Checkers/Lab03/Lab03.elm"
TIMEOUT = 3


class PlayerId(Enum):
    P1 = 1
    P2 = 2
    P3 = 3

    @property
    def prefix(self):
        return f'player{self.value}'

    @property
    def title_case(self):
        return f'Player {self.value}'


class Move(StrEnum):
    ROCK = 'Rock'
    PAPER = 'Paper'
    SCISSORS = 'Scissors'

    @property
    def suffix(self) -> str:
        return self.value.lower()

    def beats(self, other: Move) -> bool:
        match (self, other):
            case (Move.ROCK, Move.SCISSORS) | (Move.SCISSORS, Move.PAPER) | (Move.PAPER, Move.ROCK):
                return True

            case _:
                return False


class GameState(Enum):
    MOVE_SELECTION = auto()
    ROUND_RESULT = auto()
    GAME_RESULT = auto()


@dataclass(frozen=True)
class _RoundResult:
    @dataclass(frozen=True)
    class HasWinner:
        winner: PlayerId

    @dataclass(frozen=True)
    class Draw:
        pass


HasWinner, Draw = _RoundResult.HasWinner, _RoundResult.Draw
RoundResult = HasWinner | Draw


@dataclass
class Player:
    id: PlayerId
    score: int = field(default=0)


@dataclass
class Round:
    number: int
    moves: dict[PlayerId, Move]
    result: Optional[RoundResult]

    @classmethod
    def default(cls, round_number: int) -> Round:
        return cls(number=round_number, moves={}, result=None)

    def are_all_moves_ready(self) -> bool:
        return set(self.moves.keys()) == set([PlayerId.P1, PlayerId.P2, PlayerId.P3])

    def determine_round_winner(self) -> Optional[PlayerId]:
        if self.are_all_moves_ready():
            self.result = Draw()

            for player_id in self.moves.keys():
                is_winner = True

                player_move = self.moves.get(player_id)

                for other_player_id in self.all_player_ids_except(player_id):
                    other_move = self.moves.get(other_player_id)

                    if player_move and other_move:
                        if not player_move.beats(other_move):
                            is_winner = False
                            break

                if is_winner:
                    self.result = HasWinner(player_id)
                    return player_id

        return None

    def all_player_ids_except(self, player_id: PlayerId) -> Sequence[PlayerId]:
        return [pid for pid in self.moves.keys() if pid != player_id]


@dataclass
class Game:
    state: GameState
    players: dict[PlayerId, Player]
    current_round: Round
    past_rounds: list[Round]
    overall_winner: Optional[PlayerId]
    points_to_win: int

    @classmethod
    def default(cls):
        return cls(
            state=GameState.MOVE_SELECTION,
            players={
                id: Player(id) for id in
                (PlayerId.P1, PlayerId.P2, PlayerId.P3)
            },
            past_rounds=[],
            current_round=Round.default(1),
            overall_winner=None,
            points_to_win=5,
        )

    def reset(self):
        self.state = GameState.MOVE_SELECTION
        self.players = {
            id: Player(id) for id in
            (PlayerId.P1, PlayerId.P2, PlayerId.P3)
        }
        self.past_rounds = []
        self.current_round = Round.default(1)
        self.overall_winner = None

    def set_move_for_player(self, player_id: PlayerId, move: Move) -> None:
        self.current_round.moves[player_id] = move
        self.determine_round_winner()
        self.determine_overall_winner()

        if self.overall_winner:
            self.state = GameState.GAME_RESULT

        elif self.are_all_moves_ready():
            self.state = GameState.ROUND_RESULT

    def all_players(self) -> Sequence[Player]:
        return list(self.players.values())

    def all_players_except(self, player_id: PlayerId) -> Sequence[Player]:
        return [p for p in self.players.values() if p.id != player_id]

    def determine_round_winner(self):
        winner_id = self.current_round.determine_round_winner()

        if winner_id and (winner := self.players.get(winner_id)):
            winner.score += 1

    def determine_overall_winner(self):
        for player in self.all_players():
            if player.score == self.points_to_win:
                self.overall_winner = player.id

    def continue_game(self) -> None:
        self.state = GameState.MOVE_SELECTION

    def are_all_moves_ready(self) -> bool:
        return self.current_round.are_all_moves_ready()

    def is_move_ready(self, player_id: PlayerId) -> Optional[Move]:
        return self.current_round.moves.get(player_id)

    def make_next_round(self) -> None:
        previous_round = self.current_round
        self.past_rounds.append(previous_round)
        self.current_round = Round.default(previous_round.number + 1)

    def get_round_result(self) -> Optional[RoundResult]:
        return self.current_round.result


@dataclass(frozen=True)
class RandomHelper:
    seed: Optional[int] = field(default=None)

    def __post_init__(self):
        random.seed(self.seed)

    def get_random_player_order(self) -> Sequence[PlayerId]:
        ret = [PlayerId.P1, PlayerId.P2, PlayerId.P3]
        random.shuffle(ret)

        return ret

    def get_random_move(self) -> Move:
        return random.choice([Move.ROCK, Move.PAPER, Move.SCISSORS])


@dataclass(frozen=True)
class Bridge:
    br: Pylenium
    game: Game
    rnd: RandomHelper

    @classmethod
    def from_config(cls, config: PyleniumConfig) -> Bridge:
        return cls(
            Pylenium(config),
            game=Game.default(),
            rnd=RandomHelper(),
        )

    def error(self, message: str) -> NoReturn:
        print()
        pprint(self.game)
        print(f'[ERROR] {message}')
        input("Failed test case; press ENTER to end...")
        raise RuntimeError(message)

    def ensure_id_is_present(self, id: str) -> None:
        print(f'Ensuring element with ID {id} exists...')

        self.get_element_by_id(id)

    def ensure_id_is_absent(self, id: str) -> None:
        print(f'Ensuring element with ID {id} does not exist...')

        try:
            self.br.should().not_find(f'#{id}')  # pyright: ignore
        except AssertionError:
            self.error(f'Element with ID must be absent: {id}')

    def get_element_by_id(self, id: str) -> Element:
        print(f'Getting element with ID {id}...')

        try:
            return self.br.get(f'#{id}')
        except selenium.common.exceptions.InvalidSelectorException:
            self.error(f'Failed to find element with ID: {id}')

    def click_element_by_id(self, id: str) -> None:
        print(f'Clicking element with ID {id}...')
        self.get_element_by_id(id).click()

    def get_text_by_id(self, id: str) -> str:
        print(f'Getting ID {id} as text...')
        return self.get_element_by_id(f'{id}').text()

    def get_int_by_id(self, id: str) -> int:
        print(f'Getting ID {id} as int...')
        text = self.get_text_by_id(id)

        try:
            return int(text)
        except ValueError:
            self.error(f'Failed to convert text of element with ID {id} into valid int: {text}')

    def ensure_id_has_text(self, id: str, text: str) -> None:
        print(f'Ensuring ID {id} contains text: {text}')

        if self.get_text_by_id(f'{id}') != text:
            self.error(f'Element with ID must have text: {text}')

    def open_page(self):
        self.br.visit(BASE_URL)

    def simulate_single_game(self):
        self.open_page()
        self.game.reset()

        round_number = 1

        while not self.game.overall_winner:
            print(f'Round number {round_number}')

            self.verify_on_screen_elements()

            for player_id in self.rnd.get_random_player_order():
                self.simulate_random_move(player_id)

            self.verify_round_result_data()

            if self.game.overall_winner:
                self.verify_on_screen_elements()
                break

            self.simulate_continue_game()
            self.verify_on_screen_elements()
            self.verify_scores()

            round_number += 1

    def simulate_random_move(self, player_id: PlayerId):
        print(f'Simulating random move for {player_id}')

        move = self.rnd.get_random_move()
        self.verify_game_state(GameState.MOVE_SELECTION)
        self.simulate_move(player_id, move)

    def simulate_move(self, player_id: PlayerId, move: Move) -> None:
        print(f'Picking {move} for {player_id}')

        self.game.set_move_for_player(player_id, move)
        self.click_element_by_id(f'{player_id.prefix}-{move.suffix}')
        self.verify_on_screen_elements()

    def simulate_continue_game(self) -> None:
        print(f'Continuing game...')
        self.game.continue_game()
        self.click_element_by_id(f'continue')
        self.game.make_next_round()

    def verify_game_state(self, state: GameState) -> None:
        print(f'Verifying game state...')

        if self.game.state != state:
            self.error(
                f'Expected game state: {state}, actual game state: {self.game.state}')

    def verify_on_screen_elements(self) -> None:
        print(f'Verifying {self.game.state} on-screen elements...')

        match self.game.state:
            case GameState.MOVE_SELECTION:
                for player in self.game.all_players():
                    # playerN-score
                    score_on_screen = self.get_int_by_id(f"{player.id.prefix}-score")

                    if player.score != score_on_screen:
                        self.error(f'Expected score for {player.id}: {player.score}, actual score is {score_on_screen}')

                    # playerN-VARIANT
                    if self.game.is_move_ready(player.id):
                        for move in Move:
                            self.ensure_id_is_absent(f'{player.id.prefix}-{move.suffix}')
                    else:
                        for move in Move:
                            self.ensure_id_is_present(f'{player.id.prefix}-{move.suffix}')

                # playerN-move
                ...

            case GameState.ROUND_RESULT:
                # continue
                self.ensure_id_is_present('continue')

                # result
                if (expected_result := self.game.get_round_result()):
                    match expected_result:
                        case HasWinner(winner):
                            self.ensure_id_has_text('result', winner.title_case)

                        case Draw():
                            self.ensure_id_has_text('result', 'Draw')

            case GameState.GAME_RESULT:
                # restart
                self.ensure_id_is_present('restart')

                # overall-winner
                if self.game.overall_winner:
                    self.ensure_id_has_text('overall-winner', self.game.overall_winner.title_case)

    def verify_round_result_data(self) -> None:
        print(f'Verifying round results...')

    def verify_scores(self) -> None:
        print(f'Verifying scores...')


def main() -> None:
    config = PyleniumConfig()
    config.driver.version = ""
    # config.driver.browser = "firefox"

    bridge = Bridge.from_config(config)

    for game in range(1, 3):
        print(f'Game {game}')
        bridge.simulate_single_game()

    print('Success')


if __name__ == "__main__":
    main()

