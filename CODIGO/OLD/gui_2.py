from tkinter import *
import pprint

window = Tk()
window.geometry("1200x800")
window.title("Proyecto Pasantia")

def action(x,y,z):
    Label(window, text=str(x) + "," + str(y) + "," + str(z)).grid(row=0, column=17)
    #if(button % 3 == 2):
    #    change_state(button)
    #if(button % 3 == 1 and btns[button + 1].cget('bg') == 'gray'):
    #    change_state(button)
    #if(button % 3 == 0 and btns[button + 1].cget('bg') == 'gray'):
    #    change_state(button)

def change_state(button):
        if btns[button].cget('bg') == 'gray':
            btns[button].configure(bg='white')
        else:
            btns[button].configure(bg='gray')




cont_btn = 0
cont_lab = 0

size_x = 4
size_y = 5
size_z = 3

offset_x = 0
offset_y = 0

labs = []
btns = [[[0 for z in range (0, size_z)] for y in range (0, size_y)] for x in range (0, size_x)]
botones_numerados = [[[0 for k in range (0, size_z)] for j in range (0, size_y)] for i in range (0, size_x)]

for y in range (0, size_y):
    for x in range (0, size_x): 
        for z in range (0, size_z):
            btns[x][y][z] = Button(window, text='-', bg='white', padx=60, pady=10, command=(lambda x=x, y=y, z=z: action(x,y,z)))
            btns[x][y][z].grid(row=x+z+offset_x, column=y+offset_y)
            botones_numerados[x][y][z] = cont_btn
            cont_btn+=1
            if(cont_btn % size_z == 0):
                labs.append(Label(window, text="-"))
                labs[cont_lab].grid(row=x+z+offset_x+1, column=y+offset_y)
                cont_lab += 1
                offset_x += 1
        offset_x += size_z
    offset_x = 0
    offset_y += 1
    for x in range (0, size_x*size_z + size_z): 
        labs.append(Label(window, text="-"))
        labs[cont_lab].grid(row=x, column=y+offset_y)
        cont_lab += 1

pprint.pprint(botones_numerados)
window.mainloop()