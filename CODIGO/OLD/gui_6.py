from tkinter import *
from tkinter.filedialog import *
import pprint
import pathlib


def toggleFullScreen(event):
    window.fullScreenState = not window.fullScreenState
    window.attributes("-fullscreen", window.fullScreenState)

def quitFullScreen(event):
    window.fullScreenState = False
    window.attributes("-fullscreen", window.fullScreenState)

window = Tk()
#width  = window.winfo_screenwidth()
#height = window.winfo_screenheight()
#window.geometry(f'{width}x{height}')

#window.state('zoomed')
window.title("Proyecto Pasantia")
window.resizable(False, False)
window.wm_state('zoomed')

#window.attributes('-fullscreen', True)  
#window.fullScreenState = False
#window.bind("<F11>", toggleFullScreen)
#window.bind("<Escape>", quitFullScreen)


#funcion de llenado y vaciado de cointainer, cambio color gris y blanco
def action(x,y,z):
    global color
    button = btns[x][y][z]
    Label(window, text=str(x) + "," + str(y) + "," + str(z)).grid(row=0, column=8)

    if(color == ""): #Cambio de estado vacio a lleno, de colores a gris y de gris a blanco y viceversa
        try:
            #Reviso si esta lleno, si el color es gris y si esta libre arriba, asi lo vacio
            if(button[0] == 1 and button[0].cget('bg') == "gray" and btns[x][y][z+1][0] == 0): 
                button[0] = 0
                button[1].configure(bg="white")
            #Reviso si esta lleno y si lo esta saco el color y pongo gris
            elif(button[0] == 1 and button[1].cget('bg') != "gray" ): 
                button[1].configure(bg="gray")
            #Reviso si es el primer container y si esta vacio, lo lleno y pongo color gris
            elif(button[0] == 0 and z == 0):      
                button[0] = 1
                button[1].configure(bg="gray")  
            #Reviso si esta vacio el container y si el inferior tiene algo, si lo tiene lo lleno y pongo gris 
            elif(button[0] == 0 and btns[x][y][z-1][0] == 1): 
                button[0] = 1
                button[1].configure(bg="gray")
            elif(button[0] == -1):
                button[0] = 0
                button[1].configure(bg="withe")
        #Si sale la exepcion, es por que estoy fuera de la matriz (es el ultimo elemento), por lo que puedo vaciar el container y ponerlo blanco sin problemas
        except:
            button[0] = 0
            button[1].configure(bg="white")
    #cambio de colores en base a camion selecionado
    else: 
        if(btns[x][y][z][0] == 1):
            button[1].configure(bg=color)

#funcion de cambio de color a los definidos
def set_camion(camion):
    global color
    if(camion != -1):
        color = camn[camion].cget('bg')
        print(color)
    else:
        color = ""

#funcion que limpia toda la tabla
def clear_all():
    for x in range (0, size_x):
        for y in range (0, size_y):
            for z in range (0, size_z):
                btns[x][y][z][0] = 0
                btns[x][y][z][1].configure(bg="white")

#funcion de guardado de configuracion actual
def save_config():
    try:
        saved_config = asksaveasfile(mode='w', defaultextension=".txt")
        if saved_config is None: 
            return
        saved_config.write("###")
        saved_config.write("\n")
        for x in range (0, size_x):
            for y in range (0, size_y):
                for z in range (0, size_z):
                    if(btns[x][y][z][0] == 1):
                        dato = str(x) + "," + str(y) + "," + str(z) + "," + str(btns[x][y][z][1].cget('bg'))
                        saved_config.write(dato)
                        saved_config.write("\n")

        saved_config.close()   
        print("Archivo guardado")
    except:
        print("Error al guardar el archivo")

#funcion de carga de configuracion guardada
def load_config():   
    try:
        filename = askopenfilename()
        load_config = open(filename, 'r')
        datos = load_config.readlines()
        if(datos[0].strip("\n") == "###"):
            datos.pop(0)
            clear_all()

            for dato in datos: 
                dato = dato.strip("\n").split(',')
                btns[int(dato[0])][int(dato[1])][int(dato[2])][0] = 1
                btns[int(dato[0])][int(dato[1])][int(dato[2])][1].configure(bg=dato[3])   
            load_config.close()

            for x in range (0, size_x):
                for y in range (0, size_y):
                    for z in range (1, size_z):
                        if(btns[x][y][z][0] == 1 and btns[x][y][z-1][0] == 0):
                            btns[x][y][z][0] = -1
                            btns[x][y][z][1].configure(bg="red")
                            print("Archivo con datos invalidos")
                            return
                            #clear_all()
            print("Archivo cargado exitosamente")
        else:
            print("Archivo invalido")
    except:
        print("Archivo invalido")

color = ""

cont_btn = 0
cont_lab = 0

size_x = 4
size_y = 4
size_z = 3

offset_x = 0
offset_y = 0

labs = []
btns = [[[0 for z in range (0, size_z)] for y in range (0, size_y)] for x in range (0, size_x)]
camn = []
#botones_numerados = [[[0 for k in range (0, size_z)] for j in range (0, size_y)] for i in range (0, size_x)]

#Creamos la matriz de botones, cada casilla de la matriz tiene un boton y un estado (lleno o vacio)
for y in range (0, size_y):
    for x in range (0, size_x):
        for z in range (0, size_z):
            #Creamos la estructura que tiene al boton y al estado
            temp = []
            temp.append(0)
            temp.append(Button(window, text=' ', bg='white', padx=60, pady=10, command=(lambda x=y, y=3-x, z=size_z-1-z: action(x,y,z))))
            #Ingresamos la estructura a la matriz, en la posicion X,Y,Z correspondiente 
            btns[y][3-x][size_z-1-z] = temp
            btns[y][3-x][size_z-1-z][1].grid(row=x+z+offset_x, column=y+offset_y)
            btns[y][3-x][size_z-1-z][1].configure(text=str(y) + "," + str(3-x) + "," + str(size_z-1-z))
            cont_btn+=1
            #Cada size_z ingresamos un espacio en blanco, para separar las filas
            if(cont_btn % size_z == 0):
                labs.append(Label(window, text=" "))
                labs[cont_lab].grid(row=x+z+offset_x+1, column=y+offset_y)
                cont_lab += 1
        offset_x += size_z
    offset_x = 0
    offset_y += 1

    #Cada vez que termina una columna de llenarse, ingresamos un espacio en blanco hacia el lado, para separar las columnas
    labs.append(Label(window, text=" "))
    labs[cont_lab].grid(row=0, column=y+offset_y)
    cont_lab += 1

#Creamos los botones de los camiones, estan en base a la cantidad de filas X, tratando siempre de quedar al medio, si no se sube un espacio
#Mandan su numero a la funcion set_camion y en base a eso se elije el color de la lista colores
colores = ["green", "blue", "yellow"]
for c in range (-1, 2):
    camn.append(Button(window, text='CAMION ' + str(c + 1), bg=colores[c + 1], padx=60, pady=20, command=lambda camion=c + 1 : set_camion(camion)))
    camn[c + 1].grid(row=(c + int(size_x/2))*(size_z + 1) -1, column=size_y + offset_y)

#Boton de deseleccion de color, tiene el valor de -1 para indicar en la funcion set_camion la deselecion de color
Button(window, text='DE SELEC', bg="gray", padx=60, pady=10, command=lambda camion=-1 : set_camion(camion)).grid(row=0, column=10)

Button(window, text='SAVE CONFIG', bg="gray", padx=48, pady=10, command=lambda : save_config()).grid(row=1, column=10)
Button(window, text='LOAD CONFIG', bg="gray", padx=48, pady=10, command=lambda : load_config()).grid(row=2, column=10)
Button(window, text='CLEAR ALL', bg="gray", padx=48, pady=10, command=lambda : clear_all()).grid(row=3, column=10)

window.mainloop()