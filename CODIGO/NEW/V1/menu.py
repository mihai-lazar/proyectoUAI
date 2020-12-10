import time
from tkinter.filedialog import *
from grid import *

x_destino = 0
y_destino = 0
seqs = []
paso = 0
color_container = ''
error = 0

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
    
def move_cabezal():
    global seqs
    global x_destino
    global y_destino
    global paso
    global color_container
    global error
    if(len(seqs) > 0):
        error = 0
        seq = seqs[0]
        seq = seq.strip("\n").split('-')
        seq[0] = seq[0].split(',')
        seq[1] = seq[1].split(',')


        if(cabezal[2] != x_destino):
            move_x_y(cabezal[2], cabezal[3], x_destino, y_destino)
        elif(cabezal[3] != y_destino):
            move_z(cabezal[3], y_destino)
        elif(paso == 0):
            x_destino = btns[int(seq[0][0])][int(seq[0][1])][int(seq[0][2])][1].winfo_x()+pad_x_container
            y_destino = btns[int(seq[0][0])][int(seq[0][1])][2][1].winfo_y()-29
            if(abs(cabezal[2] - x_destino) >= 5):
                paso = 1
        elif(paso == 1 and abs(cabezal[3] - int(btns[int(seq[0][0])][int(seq[0][1])][int(seq[0][2])][1].winfo_y()-29)) > 5 ):
            y_destino = btns[int(seq[0][0])][int(seq[0][1])][int(seq[0][2])][1].winfo_y()-29
        elif(paso == 1):
            if(btns[int(seq[0][0])][int(seq[0][1])][int(seq[0][2])][0] == 1):
                color_container = btns[int(seq[0][0])][int(seq[0][1])][int(seq[0][2])][1].cget('bg')
                cabezal[0] = 1
                btns[int(seq[0][0])][int(seq[0][1])][int(seq[0][2])][0] = 0
                btns[int(seq[0][0])][int(seq[0][1])][int(seq[0][2])][1].configure(bg="black")   
                paso = 2
            else:
                seqs = []
                error = 1
                print("Secuancia presento error")
        elif(paso == 2 and abs(cabezal[3] - int(btns[int(seq[0][0])][int(seq[0][1])][2][1].winfo_y()-29)) > 5):
            y_destino = btns[int(seq[0][0])][int(seq[0][1])][2][1].winfo_y()-29
        elif(paso == 2):
            x_destino = btns[int(seq[1][0])][int(seq[1][1])][int(seq[1][2])][1].winfo_x()+pad_x_container
            y_destino = btns[int(seq[1][0])][int(seq[1][1])][2][1].winfo_y()-29
            if(abs(cabezal[2] - x_destino) >= 5):
                paso = 3
        elif(paso == 3 and abs(cabezal[3] - int(btns[int(seq[1][0])][int(seq[1][1])][int(seq[1][2])][1].winfo_y()-29)) > 5):
            y_destino = btns[int(seq[1][0])][int(seq[1][1])][int(seq[1][2])][1].winfo_y()-29
        elif(paso == 3):
            btns[int(seq[0][0])][int(seq[0][1])][int(seq[0][2])][1].configure(bg="white") 
            cabezal[0] = 0
            btns[int(seq[1][0])][int(seq[1][1])][int(seq[1][2])][0] = 1
            btns[int(seq[1][0])][int(seq[1][1])][int(seq[1][2])][1].configure(bg=color_container)  
            paso = 4
        elif(paso == 4 and abs(cabezal[3] - int(btns[int(seq[1][0])][int(seq[1][1])][2][1].winfo_y()-29)) > 5):
            y_destino = btns[int(seq[1][0])][int(seq[1][1])][2][1].winfo_y()-29
        elif(paso == 4):
            paso = 0   
            seqs.pop(0) 
            if(len(seqs) == 0):
                print("Secuencia ejecutada exitosamente")
    elif(error == 1):
        x_destino = 0
        y_destino = 0
        move_x_y(cabezal[2], cabezal[3], x_destino, y_destino)

    window.after(4, move_cabezal)


def move_x_y(x1, y1, x2, y2):
    if(x2 - x1 != 0):
        m = (y2 - y1)/(x2 - x1)
        x = x1
        if x1 > x2:
            x -= 1
        else:
            x += 1  
        y = m*(x-x1) + y1

        cabezal[1].place(x=x, y=y)
        cabezal[2] = x
        cabezal[3] = y

def move_z(y1, y2):
    y1 = int(y1)
    y2 = int(y2)
    if y1 > y2:
        y1 -= 1
    else:
        y1 += 1  
    cabezal[1].place(y=y1)
    cabezal[3] = y1

#funcion de carga de configuracion de sequancia
def load_seq(): 
    global seqs  
    try:
        filename = askopenfilename()
        load_config = open(filename, 'r')
        seqs = load_config.readlines()
        if(seqs[0].strip("\n") == "###SEQ"):
            seqs.pop(0)
            load_config.close()
            print("Secuencia cargada exitosamente")
        else:
            print("Archivo invalido")
    except:
        print("Archivo invalido")

btns_menu = []

alto_botones = 50
ancho_botones = 200
borde = 100
offset_y_menu = 40

#Boton de deseleccion de color, tiene el valor de -1 para indicar en la funcion set_camion la deselecion de color
btns_menu.append(Button(window, text='DE SELEC', bg="gray", padx=60, pady=10, command=lambda camion=-1 : set_camion(camion)))
btns_menu.append(Button(window, text='SAVE CONFIG', bg="gray", padx=48, pady=10, command=lambda : save_config()))
btns_menu.append(Button(window, text='LOAD CONFIG', bg="gray", padx=48, pady=10, command=lambda : load_config()))
btns_menu.append(Button(window, text='CLEAR ALL', bg="gray", padx=48, pady=10, command=lambda : clear_all()))
btns_menu.append(Button(window, text='LOAD SEQ', bg="gray", padx=48, pady=10, command=lambda : load_seq()))

for btn_menu in btns_menu:
    btn_menu.place(x=ancho_pantalla-ancho_botones, y=offset_y_menu, width=ancho_botones, height=alto_botones)
    offset_y_menu += alto_botones