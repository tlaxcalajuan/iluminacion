try:
  import usocket as socket
except:
  import socket
  
import machine 
import network

import esp
esp.osdebug(None)

import gc
gc.collect()

import time
import ubinascii
import robust
import micropython

led = machine.Pin(2, machine.Pin.OUT)
uart = machine.UART(2, 9600, tx=17, rx=16)
uart.init(9600, bits=8, parity=None, stop=1)

#ssid = 'ARRIS-C722'
#password = 'Tlaxcal@2020'

ssid = 'IZZI-B6E0'
password = 'F8F53296B6E0'

station = network.WLAN(network.STA_IF)

station.active(True)
station.disconnect()

station.connect(ssid, password)

while station.isconnected() == False:
  pass

print('Connection successful')
machine.Pin(2, machine.Pin.OUT).value(1)
time.sleep(1)
machine.Pin(2, machine.Pin.OUT).value(0)
print('Conexion con el WiFi %s establecida' % ssid)
print(station.ifconfig())

#led = machine.Pin(2, machine.Pin.OUT)

# ------------------------------------------------

#Entradas y salidas
led = machine.Pin(2, machine.Pin.OUT)
button = machine.Pin(5, machine.Pin.IN, machine.Pin.PULL_UP)
candado = False


#Cada que hay algo nuevo en las suscribciones las muestra aquí
#Nota: decode() y b'' se utiliza para poder convertir un string a byte y vice versa
def form_sub(topic, msg):
    if topic.decode() == "light": #Si el topic button recibe algo entra a las siguientes condiciones para activar / desactivar la salida
        if (msg.decode() == "on"):
            machine.Pin(2, machine.Pin.OUT).value(1)
            uart.write(msg.decode())
            print('status: led on')
        elif (msg.decode() == "off"):
            machine.Pin(2, machine.Pin.OUT).value(0)
            uart.write(msg.decode())
            print('status: led off')
    elif topic.decode() == 'distance': #Si el topic prueba recibe algo lo muestra
        print ('distancia: ' , msg.decode())
        uart.write(msg.decode())
    elif topic.decode() == 'time':
        print ('time: ' , msg.decode())
        uart.write(msg.decode())
    elif topic.decode() == 'color':
        print ('color: ' , msg.decode())
        uart.write(msg.decode())
    print((topic, msg))
    
#Función que conecta y se suscribe a MQTT
def connection_MQTT():
    client_id = '1'
    mqtt_server = '192.168.0.7'
    port_mqtt = 1883
    user_mqtt = None #Si su servidor no necesita usuario escribe None sin comillas
    pswd_mqtt = None #Si su servidor no necesita contraseña escribe None sin comillas
    client = robust.MQTTClient(client_id, mqtt_server,port_mqtt,user_mqtt,pswd_mqtt) 
    client.set_callback(form_sub)
    client.connect()
    client.subscribe(b'#')
    #client.subscribe(b'distance')
    #client.subscribe(b'time')
    #client.subscribe(b'color')
    print('Conectado a %s' % mqtt_server)
    return client

#Reinicia la conexión de MQTT
def Reinciar_conexion():
    print('Fallo en la conexion. Intentando de nuevo...')
    time.sleep(10)
    machine.reset()

#Se coloca la conexión dentro de un Try por si hay errores en la misma
try:
    client = connection_MQTT()
except OSError as e:
    Reinciar_conexion()

#Bucle
while True:
    try:
        disp_pub = client.check_msg()
    
        estado_btn = button.value()
        if disp_pub != 'None':
            if not estado_btn and not candado:
                client.publish(b'prueba', b'true')
                candado = True
                #print (estado_btn)
            elif estado_btn and candado:
                client.publish(b'prueba', b'false')
                candado = False
            #print (estado_btn)
            #time.sleep(.1)
    except OSError as e:
        Reinciar_conexion()



