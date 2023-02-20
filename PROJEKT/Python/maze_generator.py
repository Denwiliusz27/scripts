#!/usr/bin/python3
# Daniel Wielgosz (g1)

import time, random, sys, os
os.environ['PYGAME_HIDE_SUPPORT_PROMPT'] = "hide"

try:
    import pygame
except ModuleNotFoundError:
    print("\n~~~~~~~ ERROR ~~~~~~~")
    print("moduł 'pygame' nie jest zainstalowany")
    print("~~~~~~~~~~~~~~~~~~~~~\n")
    exit(0)

isWorking = True


class Cell:
    """ Klasa reprezentująca komórkę w labiryncie
        Labirynt składa się z wielu komórek, każda z nich posida współrzędne x i y, będące wartością pikselową,
        oznaczające położenie komórki w oknie
    """

    def __init__(self, x, y):
        """
            Tworzy nową komórkę o podanych wartościach
        :param x: wartość położenia w poziomie
        :param y: wartośc położenia w pionie
        """
        self.x = x
        self.y = y

    def in_list(self, lista):
        """
            Sprawdza czy komórka znajduje się w podanej liście

            :param lista: lista w której szukamy komórki

            :return: True jeśli komórka znajduje się w liście, False w przeciwnym przypadku
        """
        for i in lista:
            if i.x == self.x and i.y == self.y:
                return True
        return False


def compare_cells(cell1, cell2):
    """
        Porównuje dwie komórki (ich współrzędne)

        :param cell1: pierwsza komórka
        :param cell1: druga komórka

        :return: True: jeśli komórki mają te same współrzędne, False w przeciwnym przypadku
    """
    if cell1.x == cell2.x and cell1.y == cell2.y:
        return True
    else:
        return False


def draw_grid(grid, x_amount, y_amount, cell_w):
    """
        Służy do stworzenia i narysowania w oknie kraty, będącej podstawą do budowy labiryntu (postawienia wszystkich
        możliwych ścian)

        :param grid: słownik, którego kluczami są komórki, a wartościami listy ich sąsiadów
        :param x_amount: ilość kolumn
        :param y_amount: ilość wierszy
        :param cell_w: szerokość komórki
        :return: wypełniony słownik
    """
    y = 0

    for i in range(0, y_amount):  # tworzy kratę o podanej liczbie kolumn i wierszy
        for event in pygame.event.get():
            if event.type == pygame.QUIT:
                global isWorking
                isWorking = False
                pygame.quit()
                return grid

        x = 25
        y = y + cell_w
        for j in range(0, x_amount):
            pygame.draw.line(screen, WHITE, [x, y], [x + cell_w, y], 3)  # rysuje górną krawędź komórki
            pygame.draw.line(screen, WHITE, [x + cell_w, y], [x + cell_w, y + cell_w], 3)  # rysuje prawą krawędź
            pygame.draw.line(screen, WHITE, [x, y + cell_w], [x + cell_w, y + cell_w], 3)  # rysuje dolną krawędź
            pygame.draw.line(screen, WHITE, [x, y], [x, y + cell_w], 3)  # rysuje lewą krawędź
            pygame.display.flip()

            grid[Cell(x, y)] = []  # tworzy pustą listę sąsiadów dla komórki, będącej kluczem w słowniku
            x = x + cell_w

    return grid


def add_neighbour(grid, cell, neighbour):
    """
        Dla podanej komórki dodaje sąsiada w liście sąsiadów w słowniku

        :param grid: słownik
        :param cell: komórka, będąca kluczem słownika
        :param neighbour: komórka, która zostaje dodana do listy sasiadów komórki cell
    """
    for i in grid.keys():
        if compare_cells(cell, i):
            grid[i].append(neighbour)  # dodaje sąsiada do listy sąsiadów
        if compare_cells(neighbour, i):
            grid[i].append(cell)  # komórka zostaje dodana jako sąsiad jej sąsiada


def draw_up(grid, cell, cell_w):
    """
        Usuwa górną ścianę danej komórki przez nadpisanie, zaznacza komórkę powyżej odpowiednim kolorem, oznacza obie
        komórki jako wzajemnych sąsiadów.
        Nadpisanie następuje poprzez poprowadzenie przez obie komórki jednego prostokątu o podanym kolorze.

        :param grid: słownik
        :param cell: komórka, której górną krawędź usuwamy
        :param cell_w: szerokość komórki
    """
    up_neighbour = Cell(cell.x, cell.y - cell_w)  # komórka nad podaną komórką
    add_neighbour(grid, cell, up_neighbour)  # ustawienie relacji sasiedztwa między komórkami

    if ((cell.x == 25 ) and (cell.y == 25)):
        pygame.draw.rect(screen, GREEN, [cell.x + 2, cell.y - cell_w + 2, cell_w - 3, cell_w * 2 - 3])
    elif (cell.x == (x_cells * cell_w)) and (cell.y == (y_cells * cell_w)):
        pygame.draw.rect(screen, GREEN, [cell.x + 2, cell.y - cell_w + 2, cell_w - 3, cell_w * 2 - 3])
    else:
        pygame.draw.rect(screen, BLUE, [cell.x + 2, cell.y - cell_w + 2, cell_w - 3, cell_w * 2 - 3])


def draw_right(grid, cell, cell_w):
    """
        Usuwa prawą ścianę danej komórki przez nadpisanie, zaznacza komórkę, będącą po prawej, odpowiednim kolorem,
        oznacza obie komórki jako wzajemnych sąsiadów.
        Nadpisanie następuje poprzez poprowadzenie przez obie komórki jednego prostokątu o podanym kolorze.

        :param grid: słownik
        :param cell: komórka, której prawą krawędź usuwamy
        :param cell_w: szerokość komórki
    """
    right_neighbour = Cell(cell.x + cell_w, cell.y)  # komórka po prawej stronie od podanej komórki
    add_neighbour(grid, cell, right_neighbour)  # ustawienie relacji sasiedztwa między komórkami

    if ((cell.x == 25 ) and (cell.y == 25)):
        pygame.draw.rect(screen, GREEN, [cell.x + 2, cell.y + 2, cell_w * 2 - 3, cell_w - 3])
    elif (cell.x == (x_cells * cell_w)) and (cell.y == (y_cells * cell_w)):
        pygame.draw.rect(screen, GREEN, [cell.x + 2, cell.y + 2, cell_w * 2 - 3, cell_w - 3])
    else:
        pygame.draw.rect(screen, BLUE, [cell.x + 2, cell.y + 2, cell_w * 2 - 3, cell_w - 3])


def draw_down(grid, cell, cell_w):
    """
        Usuwa dolną ścianę danej komórki przez nadpisanie, zaznacza komórkę, będącą poniżej, odpowiednim kolorem,
        oznacza obie komórki jako wzajemnych sąsiadów.
        Nadpisanie następuje poprzez poprowadzenie przez obie komórki jednego prostokątu o podanym kolorze.


        :param grid: słownik
        :param cell: komórka, której prawą krawędź usuwamy
        :param cell_w: szerokość komórki
    """
    down_neighbour = Cell(cell.x, cell.y + cell_w)  # komórka poniżej danej komórki
    add_neighbour(grid, cell, down_neighbour)  # ustawienie relacji sasiedztwa między komórkami

    if ((cell.x == 25 ) and (cell.y == 25)):
        pygame.draw.rect(screen, GREEN, [cell.x + 2, cell.y + 2, cell_w - 3, cell_w * 2 - 3])
    elif (cell.x == (x_cells * cell_w)) and (cell.y == (y_cells * cell_w)):
        pygame.draw.rect(screen, GREEN, [cell.x + 2, cell.y + 2, cell_w - 3, cell_w * 2 - 3])
    else:
        pygame.draw.rect(screen, BLUE, [cell.x + 2, cell.y + 2, cell_w - 3, cell_w * 2 - 3])


def draw_left(grid, cell, cell_w):
    """
        Usuwa lewą ścianę danej komórki przez nadpisanie, zaznacza komórkę, będącą po lewej, odpowiednim kolorem,
        oznacza obie komórki jako wzajemnych sąsiadów.
        Nadpisanie następuje poprzez poprowadzenie przez obie komórki jednego prostokątu o podanym kolorze.

        :param grid: słownik
        :param cell: komórka, której lewą krawędź usuwamy
        :param cell_w: szerokość komórki
    """
    left_neighbour = Cell(cell.x - cell_w, cell.y)  # komórka na lewo od danej komórki
    add_neighbour(grid, cell, left_neighbour)  # ustawienie relacji sasiedztwa między komórkami

    if ((cell.x == 25 ) and (cell.y == 25)):
        pygame.draw.rect(screen, GREEN, [cell.x - cell_w + 2, cell.y + 2, cell_w * 2 - 3, cell_w - 3])
    elif (cell.x == (x_cells * cell_w)) and (cell.y == (y_cells * cell_w)):
        pygame.draw.rect(screen, GREEN, [cell.x - cell_w + 2, cell.y + 2, cell_w * 2 - 3, cell_w - 3])
    else:
        pygame.draw.rect(screen, BLUE, [cell.x - cell_w + 2, cell.y + 2, cell_w * 2 - 3, cell_w - 3])


def draw_path_cell(cell):
    """
        Rysuje punkt w labiryncie będący częścią ścieżki wyjściowej z labiryntu

        :param cell: komórka, w której rysowany jest punkt
    """
    pygame.draw.rect(screen, YELLOW, [cell.x + cell_w // 3, cell.y + cell_w // 3, cell_w // 3, cell_w // 3])
    pygame.display.flip()


def draw_single_cell(cell):
    """
        Maluje podaną komórkę odpowiednim kolorem.

        :param cell: komórka, która zostanie wypełniona danym kolorem
    """
    if ((cell.x == 25 ) and (cell.y == 25)):
        pygame.draw.rect(screen, GREEN, [cell.x + 2, cell.y + 2, cell_w - 3, cell_w - 3])
    elif (cell.x == (x_cells * cell_w)) and (cell.y == (y_cells * cell_w)):
        pygame.draw.rect(screen, GREEN, [cell.x + 2, cell.y + 2, cell_w - 3, cell_w - 3])
    else:
        pygame.draw.rect(screen, BLUE, [cell.x + 2, cell.y + 2, cell_w - 3, cell_w - 3])
    pygame.display.flip()


def draw_creating_cell(cell):
    """
        Komórka, która służy w algorytmie do tworzenia labiryntu. Zaznaczona jest innym kolorem niż reszta komórek

        :param cell: komórka tworząca labirynt, która wypełniana jest odmiennym kolorem
    """
    pygame.draw.rect(screen, RED, [cell.x + 2, cell.y + 2, cell_w - 3, cell_w - 3])
    pygame.display.flip()


def draw_maze(grid, cell_w):
    """
        Służy do stworzenia labiryntu za pomocą recursive implementation. Startując od komórki w lewym górnym rogu,
        wybiera kolejne, nieodwiedzone wcześniej komórki, zazanacza je odpowiednim kolorem, usuwając jednocześnie
        odpowiednie ściany i ustala relacje sąsiedztwa między nimi.

        :param grid: słownik, listy będące wartościami dla podanych kluczy sa uzupełniane w trakcie działania funkcji
        :param cell_w: szerokość pojedynczej komórki
        :return: uzupełniony słownik
    """
    time.sleep(1)
    stack = []  # stos na który odkładane są komórki, których sąsiadów należy sprawdzić
    visited = []  # lista odwiedzonych komórek

    cell = Cell(list(grid.keys())[0].x, list(grid.keys())[0].y)  # początkowa komórka leżąca w lewym górnym rogu
    stack.append(cell)  # komórka zostaje dodana na stos

    draw_single_cell(cell)  # komórka zostaje zaznaczona odpowiednim kolorem
    pygame.display.flip()

    while len(stack) > 0:  # pętla wykonująca się dopóki na stosie znajdują się komórki
        for event in pygame.event.get():
            if event.type == pygame.QUIT:
                global isWorking
                isWorking = False
                pygame.quit()
                return grid

        visited.append(cell)  # komórka zostaje oznaczona jako odwiedzona

        directions = []  # lista dostępnych kierunków ruchu, u - góra, r - prawo, d - dół, l - lewo
        time.sleep(0.07)

        if (Cell(cell.x, cell.y - cell_w).in_list(visited) is False) and (  # sprawdza czy komórka powyżej danej komórki
                Cell(cell.x, cell.y - cell_w).in_list(list(grid.keys())) is True):  # nie została jeszcze odwiedzona i
            directions.append("u")  # czy jest ona wśród kluczy słownika
        if (Cell(cell.x + cell_w, cell.y).in_list(visited) is False) and (  # sprawdza komórkę po prawej
                Cell(cell.x + cell_w, cell.y).in_list(list(grid.keys())) is True):
            directions.append("r")
        if (Cell(cell.x, cell.y + cell_w).in_list(visited) is False) and (  # sprawdza komórkę u dołu
                Cell(cell.x, cell.y + cell_w).in_list(list(grid.keys())) is True):
            directions.append("d")
        if (Cell(cell.x - cell_w, cell.y).in_list(visited) is False) and (  # sprawdza komórkę po lewej
                Cell(cell.x - cell_w, cell.y).in_list(list(grid.keys())) is True):
            directions.append("l")  # odpowiedni kierunek zostaje dodany do listy jako opcja kolejnego ruchu

        if len(directions) > 0:
            rand_direction = random.choice(directions)  # randomowo jest wybierany kierunek z listy dostępnych kierunków
            if rand_direction == "u":  # wybrano kierunek w górę, górna krawędź komórki jest usuwana przez nadpisanie
                draw_up(grid, cell, cell_w)  # Komórka powyżej zostaje wybrana jako nowa komórka, zostaje odpowiednio
                cell = Cell(cell.x, cell.y - cell_w)  # zaznaczona w labiryncie. Ustalana jest relacja sasiedztwa.
            elif rand_direction == "r":
                draw_right(grid, cell, cell_w)
                cell = Cell(cell.x + cell_w, cell.y)
            elif rand_direction == "d":
                draw_down(grid, cell, cell_w)
                cell = Cell(cell.x, cell.y + cell_w)
            elif rand_direction == "l":
                draw_left(grid, cell, cell_w)
                cell = Cell(cell.x - cell_w, cell.y)
            stack.append(cell)  # wybrana komórka zostaje dodana na stos
            time.sleep(0.07)
            draw_creating_cell(cell)  # wybrana komórka tworząca labirynt zostaje odpowiednio zaznaczona
            pygame.display.flip()
        else:  # w przypadku kiedy dla danej komórki nie ma możliwości poruszenia w żadnym kierunku
            draw_single_cell(cell)
            time.sleep(0.07)
            cell = stack.pop()  # ze stosu zostaje pobrana i usunięta ostatnio dodana komórka
            draw_creating_cell(cell)

    draw_single_cell(cell)
    return grid


def find_path(grid):
    """
        Służy do znalezienia ścieżki między komórą w lewym górnym rogu, a komórką w prawym dolnym.
        Założenie podobne jak przy tworzeniu labiryntu.

        :param grid: słownik, na którego podstawie szukana jest ścieżka
    """
    last_nr = len(list(grid.keys()))
    last_cell = list(grid.keys())[last_nr - 1]  # komórka będąca w prawym dolnym rogu labiryntu (końcowa)

    cell = list(grid.keys())[0]  # komórka w lewym górnym rogu (startowa)
    stack = []  # stos na który odkładane są komórki, których sąsiadów należy sprawdzić
    visited = []  # lista odwiedzonych komórek

    while not compare_cells(cell, last_cell):  # pętla wykonująca się, dopóki program nie natrafi na komórkę końcową
        for event in pygame.event.get():
            if event.type == pygame.QUIT:
                global isWorking
                isWorking = False
                pygame.quit()
                return grid

        neighbours = []  # lista sąsiadów danej komórki
        visited.append(cell)  # komórka zostaje dodana do listy komórek odwiedzonych
        draw_path_cell(cell)  # w podanej komórce zostaje narysowany punkt będący elementem ścieżki

        for i in grid.keys():  # pętla dodaje do listy sąsiadów komórki, do których można przejść z podanej komórki (nie
            if compare_cells(cell, i):  # wystepuje między nimi ściana), a którzy nie zostali jeszcze odwiedzeni
                for j in grid[i]:
                    if not j.in_list(visited):
                        neighbours.append(j)
                break

        if len(neighbours) > 0:  # jeśli komórka posiada nieodwiedzonych sasiadów, zostaje wybrany jeden z nich, a
            stack.append(cell)  # komórka dodana na stos
            cell = random.choice(neighbours)
        else:  # jeśli wszyscy sąsiedzi komórki zostali odwiedzeni, zostaje pobrana i usunięta komórka ze szczytu stosu
            time.sleep(0.15)
            draw_single_cell(cell)
            cell = stack.pop()

        time.sleep(0.15)

    draw_path_cell(cell)


def main_loop():
    """
        Główna pętla programu
    """
    while True:
        for event in pygame.event.get():
            if event.type == pygame.QUIT:
                pygame.quit()
                exit(0)
        clock.tick(60)


def display_help(option):
    if (option[:2] != './'):
        option = 'python3 ' + option

    print("\n~~~~~~~~~~~~~~~~~~~~~ OPIS ~~~~~~~~~~~~~~~~~~~~~")
    print("Program służy do generowania labiryntu oraz znajdowania")
    print("ścieżki wyjścia. Ścieżka rozpoczyna się w lewym górnym rogu,")
    print("a kończy w prawym dolnym rogu.\n")
    print("W celu uruchomienia programu należy podać:")
    print("- całkowitą wartość liczbową* większą od 1, oznaczającą szerokość labiryntu")
    print("- całkowitą wartość liczbową* większą od 1, oznaczającą wysokość labiryntu")
    print("Przykład wywołania:")
    print("     ", option, "10 10")
    print("W wyniku takiego wywołania programu, na ekranie powinno pojawić")
    print("się okno o podanych rozmiarach.")
    print("\n*im większą liczbę podamy, tym dłużej program będzie generował")
    print("labirynt.")
    print("\nMożliwe jest przerwanie wykonywania programu w dowolnym momencie")
    print("poprzez kliknięcię w krzyżyk, umieszczony w rogu okna.")
    print("\nUWAGA: do uruchomienia programu wymagana jest zainstalowana biblioteka 'pygame',")
    print("program powinien być również uruchomiony w środowisku graficznym - w innym przypadku")
    print("może on wykazać nieprawidłowe działanie.")
    print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n")


def arg_not_int_error(arg):
    print("\n~~~~~~~ ERROR ~~~~~~~")
    print("'", arg, "' nie jest liczbą całkowitą")
    print("~~~~~~~~~~~~~~~~~~~~~\n")
    exit(1)

def graphical_context_error():
    print("\n~~~~~~~ ERROR ~~~~~~~")
    print("Środowisko graficzne nie jest dostępne.")
    print("~~~~~~~~~~~~~~~~~~~~~\n")
    exit(1)

if __name__ == '__main__':
    RED = (255, 0, 0)
    YELLOW = (255, 255, 0)
    WHITE = (255, 255, 255)
    BLUE = (0, 0, 255)
    GREEN = (0, 255, 0)

    x_cells = 0
    y_cells = 0

    for i in range(1, len(sys.argv)):
        if sys.argv[i] == '-h':
            display_help(sys.argv[0])
            exit(0)
        else:
            if x_cells == 0:
                try:
                    x_cells = int(sys.argv[i])
                except ValueError:
                    arg_not_int_error(sys.argv[i])
            else:
                try:
                    y_cells = int(sys.argv[i])
                except ValueError:
                    arg_not_int_error(sys.argv[i])

    if (len(sys.argv) < 3) or (len(sys.argv) > 3):
        print("\n~~~~~~~ ERROR ~~~~~~~")
        print("Niewłaściwa liczba argumentów")
        print("~~~~~~~~~~~~~~~~~~~~~\n")
        exit(1)

    if x_cells <= 1 or y_cells <= 1:
        print("\n~~~~~~~ ERROR ~~~~~~~")
        print("Podane wartości powinny być")
        print("wartościami większymi od 1")
        print("~~~~~~~~~~~~~~~~~~~~~\n")
        exit(1)

    pygame.init()

    import tkinter as tk

    try:
        root = tk.Tk()
        root.destroy()
    except tk.TclError:
        graphical_context_error()

    cell_w = 25  # szerokość komórki
    width = 50 + x_cells * cell_w  # szerokość okna dostosowana do wielkości labiryntu
    hight = 50 + y_cells * cell_w  # wysokość okna dostosowana do wielkości labiryntu

    screen = pygame.display.set_mode((width, hight))

    try:
        pygame.display.set_caption("Maze generator")
    except pygame.error:
        graphical_context_error()
    
    if pygame.display.get_init():
        if not pygame.display.Info().wm == 1:
            graphical_context_error()

        clock = pygame.time.Clock()

        grid = {}  # słownik wykorzystywany w reszcie funkcji

        grid = draw_grid(grid, x_cells, y_cells, cell_w)
        if isWorking:
            grid = draw_maze(grid, cell_w)
        if isWorking:
            find_path(grid)
        if isWorking:
            main_loop()
    else:
        graphical_context_error()

