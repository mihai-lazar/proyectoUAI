import time
from tkinter.filedialog import *
from grid import *

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
    

def move_x_y(x1, y1, x2, y2):
    x1 = int(x1)
    x2 = int(x2)
    m = (y2 - y1)/(x2 -x1)
    x = x1
    while x != x2:
        y = m*(x-x1) + y1
        cabezal[1].place(x=x, y=y)
        cabezal[2] = x
        cabezal[3] = y
        window.update()
        if x1 > x2:
            x -= 1
        else:
            x += 1  
        time.sleep(0.005)  

def move_z(y1, y2):
    y1 = int(y1)
    y2 = int(y2)
    print("-------")
    print(y1)
    print(y2)
    while y1 != y2:
        if y1 > y2:
            y1 -= 1
        else:
            y1 += 1  
        cabezal[1].place(y=y1)
        cabezal[3] = y1
        window.update()
        time.sleep(0.005) 

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

                    move_x_y(cabezal[2], cabezal[3],
                             btns[int(seq[0][0])][int(seq[0][1])][int(seq[0][2])][1].winfo_x()+pad_x_container, btns[int(seq[0][0])][int(seq[0][1])][2][1].winfo_y()-29)
                    time.sleep(1)
                    if(abs(cabezal[3] - int(btns[int(seq[0][0])][int(seq[0][1])][int(seq[0][2])][1].winfo_y()-29)) > 5):
                        move_z(cabezal[3], btns[int(seq[0][0])][int(seq[0][1])][int(seq[0][2])][1].winfo_y()-29)
                        time.sleep(1)
                    color_container = btns[int(seq[0][0])][int(seq[0][1])][int(seq[0][2])][1].cget('bg')
                    cabezal[0] = 1
                    btns[int(seq[0][0])][int(seq[0][1])][int(seq[0][2])][0] = 0
                    btns[int(seq[0][0])][int(seq[0][1])][int(seq[0][2])][1].configure(bg="black")   

                    if(abs(cabezal[3] - int(btns[int(seq[0][0])][int(seq[0][1])][2][1].winfo_y()-29)) > 5):
                        move_z(cabezal[3], btns[int(seq[0][0])][int(seq[0][1])][2][1].winfo_y()-29)
                        time.sleep(1)
                    move_x_y(cabezal[2], cabezal[3],
                             btns[int(seq[1][0])][int(seq[1][1])][int(seq[1][2])][1].winfo_x()+pad_x_container, btns[int(seq[1][0])][int(seq[1][1])][2][1].winfo_y()-29)
                    time.sleep(1)

                    if(abs(cabezal[3] - int(btns[int(seq[1][0])][int(seq[1][1])][int(seq[1][2])][1].winfo_y()-29)) > 5):
                        move_z(cabezal[3], btns[int(seq[1][0])][int(seq[1][1])][int(seq[1][2])][1].winfo_y()-29)
                        time.sleep(1)
                    btns[int(seq[0][0])][int(seq[0][1])][int(seq[0][2])][1].configure(bg="white") 
                    cabezal[0] = 0
                    btns[int(seq[1][0])][int(seq[1][1])][int(seq[1][2])][0] = 1
                    btns[int(seq[1][0])][int(seq[1][1])][int(seq[1][2])][1].configure(bg=color_container)  

                    if(abs(cabezal[3] - int(btns[int(seq[1][0])][int(seq[1][1])][2][1].winfo_y()-29)) > 5):
                        move_z(cabezal[3], btns[int(seq[1][0])][int(seq[1][1])][2][1].winfo_y()-29)
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