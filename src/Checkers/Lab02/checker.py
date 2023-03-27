from dataclasses import dataclass
import random
from typing import Literal, Optional, TypeGuard

from pylenium.config import PyleniumConfig
from pylenium.driver import Pylenium


Player = Literal['Player 1', 'Player 2']

BASE_URL = "http://localhost:8000/Src/Checkers/Lab02/Lab02.elm"
TIMEOUT = 3


@dataclass(frozen=True)
class Path:
    CURRENT_PLAYER = "span#current-player"
    N = "span#n"
    K = "span#k"
    BUTTON_TEMPLATE = "button#choice-{}"
    MOVES_PLAYER_1 = "span#moves-player1"
    MOVES_PLAYER_2 = "span#moves-player2"
    RESTART = "button#restart"

    @classmethod
    def button(cls, num: int) -> str:
        return cls.BUTTON_TEMPLATE.format(num)


@dataclass(frozen=True)
class Content:
    @classmethod
    def n(cls, br: Pylenium) -> int:
        return int(br.get(Path.N).text())

    @classmethod
    def k(cls, br: Pylenium) -> int:
        return int(br.get(Path.K).text())

    @classmethod
    def current_player(cls, br: Pylenium) -> Player:
        text = br.get(Path.CURRENT_PLAYER).text()

        if cls._is_current_player(text):
            return text

        assert False, f'{text} is not valid Player text'

    @classmethod
    def moves_player1(cls, br: Pylenium) -> list[int]:
        return eval(br.get(Path.MOVES_PLAYER_1).text())

    @classmethod
    def moves_player2(cls, br: Pylenium) -> list[int]:
        return eval(br.get(Path.MOVES_PLAYER_2).text())

    @classmethod
    def _is_current_player(cls, text: str) -> TypeGuard[Player]:
        return text in ("Player 1", "Player 2")


@dataclass(frozen=True)
class Click:
    @classmethod
    def button(cls, br: Pylenium, num: int) -> None:
        return br.get(Path.button(num)).click()  # pyright: ignore


@dataclass(frozen=True)
class Check:
    @classmethod
    def visibility(cls, br: Pylenium, css_path: str) -> None:
        assert br.get(css_path).should(timeout=TIMEOUT).be_visible()  # pyright: ignore

    @classmethod
    def content(cls, br: Pylenium, css_path: str, text: str) -> None:
        assert br.get(css_path).should(timeout=TIMEOUT).have_text(text=text, case_sensitive=False)  # pyright: ignore

    @classmethod
    def current_player(cls, br: Pylenium) -> None:
        player = Content.current_player(br)

        assert player in ("Player 1", "Player 2")

    @classmethod
    def n(cls, br: Pylenium) -> None:
        n = Content.n(br)
        assert 1000 <= n and n <= 1000000

    @classmethod
    def k(cls, br: Pylenium) -> None:
        n = Content.n(br)
        k = Content.k(br)

        assert k < n

    @classmethod
    def moves(cls, br: Pylenium) -> None:
        moves_player1 = Content.moves_player1(br)
        moves_player2 = Content.moves_player2(br)

        assert len(moves_player1) - len(moves_player2) <= 1


    @classmethod
    def expected_elements(cls, br: Pylenium):
        cls.visibility(br, Path.CURRENT_PLAYER)
        cls.visibility(br, Path.N)
        cls.visibility(br, Path.K)

        for i in range(2, 10):
            cls.visibility(br, Path.button(i))

        cls.visibility(br, Path.MOVES_PLAYER_1)
        cls.visibility(br, Path.MOVES_PLAYER_2)


    @classmethod
    def default_values(cls, br: Pylenium) -> None:
        cls.content(br, Path.CURRENT_PLAYER, "Player 1")
        cls.content(br, Path.K, "2")

        for i in range(2, 10):
            cls.content(br, Path.button(i), f"{i}")

        cls.content(br, Path.MOVES_PLAYER_1, "[]")
        cls.content(br, Path.MOVES_PLAYER_2, "[]")

        cls.invariants(br)


    @classmethod
    def invariants(cls, br: Pylenium) -> None:
        cls.n(br)
        cls.k(br)
        cls.moves(br)


    @classmethod
    def single_turn(cls, br: Pylenium) -> Optional[Player]:
        current_player = Content.current_player(br)
        n = Content.n(br)
        k = Content.k(br)
        moves_player1 = Content.moves_player1(br)
        moves_player2 = Content.moves_player2(br)

        cls.invariants(br)
        choice = random.randint(2, 9)
        Click.button(br, choice)

        expected_k = k * choice

        if expected_k >= n:
            return current_player

        cls.invariants(br)

        next_k = Content.k(br)
        assert expected_k == next_k

        next_player = Content.current_player(br)
        assert current_player != next_player
        cls.current_player(br)

        next_n = Content.n(br)
        assert n == next_n

        next_moves_player1 = Content.moves_player1(br)
        next_moves_player2 = Content.moves_player2(br)

        if current_player == "Player 1":
            assert [choice] + moves_player1 == next_moves_player1
            assert moves_player2 == next_moves_player2
        else:
            assert moves_player1 == next_moves_player1
            assert [choice] + moves_player2 == next_moves_player2

        return None


    @classmethod
    def single_round(cls, br: Pylenium) -> None:
        while True:
            cls.expected_elements(br)

            if (winner := cls.single_turn(br)):
                break

            cls.expected_elements(br)

        loser = "Player 2" if winner == "Player 1" else "Player 1"
        br.contains(winner + " wins")

        entire_text = (br.get('body').webelement.get_attribute("innerText"))  # pyright: ignore
        assert loser + " wins" not in entire_text

        br.get(Path.RESTART).click()
        # input("Press [Enter] to continue")


def main() -> None:
    config = PyleniumConfig()
    config.driver.version = ""

    br = Pylenium(config)
    br.visit(BASE_URL)

    for round in range(1, 11):
        print(f'Round {round}')
        Check.expected_elements(br)
        Check.default_values(br)
        Check.single_round(br)

    print('Success')


if __name__ == "__main__":
    main()

