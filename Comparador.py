import pygame

pygame.init()

X = 1100
Y = 700

display_surface = pygame.display.set_mode((X, Y))
pygame.display.set_caption('Proyecto 1 para Arquitectura de Computadores 1 de Esteban Andrés Zúñiga Orozco')

image = pygame.image.load(r'/home/esteban/Desktop/Arqui1/Proyecto1/Pruebas/bosque.png')
image = pygame.transform.scale(image, (425, 275))
image2 = pygame.image.load(r'/home/esteban/Desktop/Arqui1/Proyecto1/Resultado/ecualizada.png')
image2 = pygame.transform.scale(image2, (425, 275))
image3 = pygame.image.load(r'/home/esteban/Desktop/Arqui1/Proyecto1/Histogramas/histoOriginal.png')
image3 = pygame.transform.scale(image3, (425, 275))
image4 = pygame.image.load(r'/home/esteban/Desktop/Arqui1/Proyecto1/Histogramas/histoEcualizada.png')
image4 = pygame.transform.scale(image4, (425, 275))

white = (255,255,255)
font = pygame.font.SysFont('arial.ttf', 45)
font2 = pygame.font.SysFont('arial.ttf', 25)

text = font.render("Ecualizador de histogramas", True, white)
textRect = text.get_rect()
textRect.center = ( X//2, 30)
label1 = font2.render("Imagen original:", True, white)
textRect1 = label1.get_rect()
textRect1.center = (X//4, (Y//8)-25)
label2 = font2.render("Imagen ecualizada:", True, white)
textRect2 = label2.get_rect()
textRect2.center = (X//4, (1.25*Y//2)-50)
label3 = font2.render("Histograma de imagen original:", True, white)
textRect3 = label3.get_rect()
textRect3.center = (3*X//4, (Y//8)-25)
label4 = font2.render("Histograma de imagen ecualizada:", True, white)
textRect4 = label4.get_rect()
textRect4.center = (3*X//4, (1.25*Y//2)-50)

while True:
    display_surface.fill(color="#58BF0C")
    display_surface.blit(image, ((X//4)-200, 75))
    display_surface.blit(image2, ((X//4)-200, 400))
    display_surface.blit(image3, ((X//2)+75, 75))
    display_surface.blit(image4, ((X//2)+75, 400))
    display_surface.blit(text, textRect)
    display_surface.blit(label1, textRect1)
    display_surface.blit(label2, textRect2)
    display_surface.blit(label3, textRect3)
    display_surface.blit(label4, textRect4)

    for event in pygame.event.get():
        if event.type == pygame.QUIT:
            pygame.quit()
            quit()
        pygame.display.update()