from window import *

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

#funcion de cambio de color a los definidos
def set_camion(camion):
    global color
    if(camion != -1):
        color = camn[camion].cget('bg')
        print(color)
    else:
        color = ""

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


cabezal = []
cabezal.append(0)
cabezal.append(Button(window, text="", bg="brown", state=DISABLED))
print(btns[0][0][0][1].winfo_rootx())
cabezal[1].place(x=btns[0][0][0][1].winfo_rootx()+pad_x_container, y=btns[0][0][0][1].winfo_rooty(), width=30, height=30)
cabezal.append(btns[0][0][0][1].winfo_rootx()+pad_x_container)
cabezal.append(btns[0][0][0][1].winfo_rooty())

btns[0][0][0][1].configure(bg="blue")
print(btns[0][0][0][1].winfo_rooty())
print(btns[0][0][0][1])
