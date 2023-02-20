#!/usr/bin/python3
# Daniel Wielgosz (g1)

import sys
from random import randint

try:
    import pygame
except ModuleNotFoundError:
    print("\n~~~~~~~ ERROR ~~~~~~~")
    print("moduł 'pygame' nie jest zainstalowany")
    print("~~~~~~~~~~~~~~~~~~~~~\n")
    exit(0)


pygame.init()
pygame.font.init()
# font = pygame.font.SysFont("Arial", 50, bold=False, italic=False)
# SysFont(“Arial”, 72)


# kolory
CZARNY = (0, 0, 0)
BIALY = (255, 255, 255)


class Rakietka(pygame.sprite.Sprite):
    # klasa Rakietka dziedziczy z klasy "Sprite" w Pygame.

    def __init__(self, color, width, height):
        # wołamy najpierw konstruktor klasy bazowej (Sprite)
        # dzięki metodzie super() dziedziczymy wszystkie elementy klasy bazowej
        super().__init__()

        # przekazanie koloru Rakietka oraz szerokości i wysokości, kolor tła i ustawienie go na przezroczyste
        self.image = pygame.Surface([width, height])
        self.image.fill(CZARNY)
        self.image.set_colorkey(CZARNY)
        # self.font = pygame.font.SysFont("Arial", 50, bold=False, italic=False)

        # rysuję Rakietka jako prostokąt
        pygame.draw.rect(self.image, color, [0, 0, width, height])

        # pobieramy prostokąt (jego rozmiary) z obiektu image
        self.rect = self.image.get_rect()

    def moveLeft(self, pixels):
        self.rect.x -= pixels
        # sprawdzanie położenia brzegowego
        if self.rect.x < 0:
            self.rect.x = 0

    def moveRight(self, pixels):
        self.rect.x += pixels
        # sprawdzanie położenia brzegowego
        if self.rect.x > 600:
            self.rect.x = 600


class Pilka(pygame.sprite.Sprite):
    # klasa Pilka dziedziczy ze "Sprite" w Pygame.

    def __init__(self, color, width, height):
        # wołamy konstruktor klasy bazowej
        super().__init__()

        # przekazujemy rozmiary, kolor, przezroczystość
        self.image = pygame.Surface([width, height])
        self.image.fill(CZARNY)
        self.image.set_colorkey(CZARNY)

        # rysowanie piłki (jako prostokącika)
        pygame.draw.rect(self.image, color, [0, 0, width, height])

        # losowanie prędkości
        self.velocity = [randint(-4, 4), randint(2, 6)]

        # pobieramy prostokąt (jego rozmiary) z obiektu image
        self.rect = self.image.get_rect()

    def update(self):
        self.rect.x += self.velocity[0]
        self.rect.y += self.velocity[1]

    def bounce(self):
        self.velocity[1] = -self.velocity[1]
        self.velocity[0] = randint(-8, 8)


def main():
    font = pygame.font.SysFont("Arial", 50, bold=False, italic=False)

    # definiujemy rozmiary i otwieramy nowe okno
    size = (700, 500)
    screen = pygame.display.set_mode(size)
    pygame.display.set_caption("Ping Pong")

    rakietkaA = Rakietka(BIALY, 100, 10)
    rakietkaA.rect.x = 300
    rakietkaA.rect.y = 470

    pileczka = Pilka(BIALY, 10, 10)
    pileczka.rect.x = randint(0, 690)
    pileczka.rect.y = randint(0, 150)

    # lista wszystkich widzalnych obiektów potomnych z klasy Sprite
    all_sprites_list = pygame.sprite.Group()

    # dodanie obu rakietek i piłeczki do listy
    all_sprites_list.add(rakietkaA)
    all_sprites_list.add(pileczka)

    # zaczynamy właściwy blok programu
    kontynuuj = True

    # służy do kontroli liczby klatek na sekudnę (fps)
    clock = pygame.time.Clock()

    # Początkowe wyniki graczy
    scoreA = 0

    # -------- GLÓWNA PĘTLA PROGRAMU -----------
    while kontynuuj:
        for event in pygame.event.get():
            if event.type == pygame.QUIT:  # zamknięcie okienka
                kontynuuj = False

        # ruchy obiektów Rakietkas klawisze strzałka lewo prawo
        keys = pygame.key.get_pressed()
        if keys[pygame.K_LEFT]:
            rakietkaA.moveLeft(5)
        if keys[pygame.K_RIGHT]:
            rakietkaA.moveRight(5)

        # aktualizacja listy duszków
        all_sprites_list.update()

        if pileczka.rect.x > 690:
            pileczka.velocity[0] = -pileczka.velocity[0]
        if pileczka.rect.x < 0:
            pileczka.velocity[0] = -pileczka.velocity[0]
        if pileczka.rect.y >= 490:
            file = open("wynik.txt", "r")
            wynik = int(file.read())
            file.close()

            # font = pygame.font.Font(None, 74)
            text = font.render("Koniec gry", 1, (255, 0, 0))
            screen.blit(text, (220, 140))


            if scoreA > wynik:
                file = open("wynik.txt", "w")
                file.write(str(scoreA))
                wynik = scoreA
                file.close()

                while True:
                    try:
                        # font = pygame.font.Font(None, 74)
                        text = font.render("Nowy rekord! ", 1, (0, 255, 0))
                        screen.blit(text, (200, 210))
                        # font = pygame.font.Font(None, 74)
                        text = font.render("Max wynik: ", 1, BIALY)
                        screen.blit(text, (200, 280))
                        # font = pygame.font.Font(None, 74)
                        text = font.render(str(wynik), 1, (255, 255, 0))
                        screen.blit(text, (490, 280))
                        pygame.display.flip()
                    except pygame.error:
                        print("error")

                    for event in pygame.event.get():
                        if event.type == pygame.QUIT:  # zamknięcie okienka
                            pygame.quit()
            else:
                while True:
                    # font = pygame.font.Font(None, 74)
                    try:
                        txt = 'Max wynik: '
                        text = font.render(str(txt),  1, (255, 255, 0))
                        screen.blit(text, (200, 210))
                        # font = pygame.font.Font(None, 74)
                        text = font.render(str(wynik), 1, (255, 255, 0))
                        screen.blit(text, (490, 210))
                        pygame.display.flip()
                    except pygame.error:
                        print("error")

                    for event in pygame.event.get():
                        if event.type == pygame.QUIT:  # zamknięcie okienka
                            pygame.quit()

        if pileczka.rect.y <= 0:
            pileczka.velocity[1] = -pileczka.velocity[1]

            # sprawdzenie kolizji piłeczki z obiektem rakietkaA
        if pygame.sprite.collide_mask(pileczka, rakietkaA):
            scoreA += 1
            pileczka.bounce()

            # RYSOWANIE
            # czarny ekran
        screen.fill(CZARNY)
        # cienka linia przez środek boiska
        # pygame.draw.line(screen, BIALY, [0, 249], [699, 249], 5)

        # narysowanie obiektów
        all_sprites_list.draw(screen)

        # wyświetlanie wyników
        # font = pygame.font.Font(None, 74)
        text = font.render(str(scoreA), 1, (0, 255, 255))
        if scoreA >= 10:
            screen.blit(text, (310, 10))
        else:
            screen.blit(text, (330, 10))

        # odświeżenie / przerysowanie całego ekranu
        pygame.display.flip()

        # 60 klatek na sekundę

        # sprawdzenie czy piłeczka nie uderza w którąś ścianę
        # i odpowiednie naliczenie punktu jeśli minie rakietkę A i uderzy w ścianę pod nią
        clock.tick(60)


if __name__ == '__main__':
    main()
    print("To koniec")
    sys.exit()
    # koniec
