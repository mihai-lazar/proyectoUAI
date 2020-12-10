from tkinter import *
from tkinter.filedialog import *
import pprint
import pathlib
import time

window = Tk()
window.title("Proyecto Pasantia")
window.resizable(False, False)
window.wm_state('zoomed')
alto_pantalla = int(window.winfo_screenheight())
ancho_pantalla = int(window.winfo_screenwidth())

#funcion de llenado y vaciado de cointainer, cambio color gris y blanco
def action(x,y,z):
    global color
    button = btns[x][y][z]
    Label(window, text=str(x) + "," + str(y) + "," + str(z)).grid(row=0, column=8)

    if(color == ""): #Cambio de estado vacio a lleno, de colores a gris y de gris a blanco y viceversa
        try:
            #Reviso si esta lleno, si el color es gris y si esta libre arriba, asi lo vacio
            if(button[0] == 1 and button[1].cget('bg') == "gray" and btns[x][y][z+1][0] == 0): 
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
        saved_config.write("###CONF")
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
        if(datos[0].strip("\n") == "###CONF"):
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

#funcion de carga de configuracion de sequancia
def load_seq():   
    try:
        filename = askopenfilename()
        load_config = open(filename, 'r')
        seqs = load_config.readlines()
        if(seqs[0].strip("\n") == "###SEQ"):
            seqs.pop(0)

            for seq in seqs: 
                seq = seq.strip("\n").split('-')
                seq[0] = seq[0].split(',')
                seq[1] = seq[1].split(',')

                if(btns[int(seq[0][0])][int(seq[0][1])][int(seq[0][2])][0] == 1):

                    cabezal.place(x=btns[int(seq[0][0])][int(seq[0][1])][int(seq[0][2])][1].winfo_rootx()+pad_x_container, y=btns[int(seq[0][0])][int(seq[0][1])][int(seq[0][2])][1].winfo_rooty()-pad_y_container-5)
                    btns[int(seq[0][0])][int(seq[0][1])][int(seq[0][2])][0] = 0
                    btns[int(seq[0][0])][int(seq[0][1])][int(seq[0][2])][1].configure(bg="black")   
                    btns[int(seq[1][0])][int(seq[1][1])][int(seq[1][2])][0] = 1
                    btns[int(seq[1][0])][int(seq[1][1])][int(seq[1][2])][1].configure(bg="black")   
                    window.update()
                    time.sleep(1)
                    
                    cabezal.place(x=btns[int(seq[1][0])][int(seq[1][1])][int(seq[1][2])][1].winfo_rootx()+pad_x_container, y=btns[int(seq[1][0])][int(seq[1][1])][int(seq[1][2])][1].winfo_rooty()-pad_y_container-5)
                    btns[int(seq[0][0])][int(seq[0][1])][int(seq[0][2])][1].configure(bg="white") 
                    btns[int(seq[1][0])][int(seq[1][1])][int(seq[1][2])][1].configure(bg="gray")  
                    window.update()
                    time.sleep(1)
                else:
                    print("Secuencia con errores")
                    return

            load_config.close()

            print("Secuencia ejecutada exitosamente")
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

pad_x_container = 60
pad_y_container = 10

#Creamos la matriz de botones, cada casilla de la matriz tiene un boton y un estado (lleno o vacio)
for x in range (0, size_x):
    for y in range (0, size_y):
        for z in range (0, size_z):
            #Creamos la estructura que tiene al boton y al estado
            temp = []
            temp.append(0)
            temp.append(Button(window, text=' ', bg='white', padx=pad_x_container, pady=pad_y_container, command=(lambda x=x, y=size_y-1-y, z=size_z-1-z: action(x,y,z))))
            #Ingresamos la estructura a la matriz, en la posicion X,Y,Z correspondiente 
            btns[x][size_y-1-y][size_z-1-z] = temp
            btns[x][size_y-1-y][size_z-1-z][1].grid(row=y+z+offset_y, column=x+offset_x)
            btns[x][size_y-1-y][size_z-1-z][1].configure(text=str(x) + "," + str(size_y-1-y) + "," + str(size_z-1-z))
            cont_btn+=1
            #Cada size_z ingresamos un espacio en blanco, para separar las filas
            if(cont_btn % size_z == 0):
                labs.append(Label(window, text=" "))
                labs[cont_lab].grid(row=y+z+offset_y+1, column=x+offset_x)
                cont_lab += 1
        offset_y += size_z
    offset_y = 0
    offset_x += 1

    #Cada vez que termina una columna de llenarse, ingresamos un espacio en blanco hacia el lado, para separar las columnas
    labs.append(Label(window, text=" "))
    labs[cont_lab].grid(row=0, column=x+offset_x)
    cont_lab += 1

#Creamos los botones de los camiones, estan en base a la cantidad de filas X, tratando siempre de quedar al medio, si no se sube un espacio
#Mandan su numero a la funcion set_camion y en base a eso se elije el color de la lista colores
colores = ["green", "blue", "yellow"]
for c in range (-1, 2):
    camn.append(Button(window, text='CAMION ' + str(c + 1), bg=colores[c + 1], padx=60, pady=20, command=lambda camion=c + 1 : set_camion(camion)))
    camn[c + 1].grid(row=(c + int(size_y/2))*(size_z + 1) -1, column=size_x + offset_x)

#Boton de deseleccion de color, tiene el valor de -1 para indicar en la funcion set_camion la deselecion de color

btns_menu = []

alto_botones = 50
ancho_botones = 200
borde = 100
offset_y_menu = 40

btns_menu.append(Button(window, text='DE SELEC', bg="gray", padx=60, pady=10, command=lambda camion=-1 : set_camion(camion)))
btns_menu.append(Button(window, text='SAVE CONFIG', bg="gray", padx=48, pady=10, command=lambda : save_config()))
btns_menu.append(Button(window, text='LOAD CONFIG', bg="gray", padx=48, pady=10, command=lambda : load_config()))
btns_menu.append(Button(window, text='CLEAR ALL', bg="gray", padx=48, pady=10, command=lambda : clear_all()))
btns_menu.append(Button(window, text='LOAD SEQ', bg="gray", padx=48, pady=10, command=lambda : load_seq()))

for btn_menu in btns_menu:
    btn_menu.place(x=ancho_pantalla-ancho_botones, y=offset_y_menu, width=ancho_botones, height=alto_botones)
    offset_y_menu += alto_botones



cabezal = Button(window, text="", bg="brown", state=DISABLED)
cabezal.place(x=0, y=0, width=30, height=30)


window.mainloop()