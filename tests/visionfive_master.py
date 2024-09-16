import os
import sys
import time
import logging
import VisionFive.spi as spi
import VisionFive.gpio as gpio

# Definir os parâmetros do SPI
SPI_DEV = "/dev/spidev1.0"    # Dispositivo SPI (exemplo: /dev/spidev0.0)
SPI_CLOCK = 10000000  # Frequência de 40 MHz
SPI_MODE = 1          # Modo SPI (CPOL=0, CPHA=0)
SPI_BITS_PER_WORD = 8 # Transferir 8 bits por vez

class SPI_Communication:
    def __init__(self, dev):
        self.spidev = dev
        spi.getdev(self.spidev)
        spi.setmode(SPI_CLOCK, SPI_MODE, SPI_BITS_PER_WORD)  # Configura o SPI

    def __del__(self):
        spi.freedev()  # Libera o dispositivo SPI

    def spi_send(self, data):
        """Envia uma lista de bytes pela SPI."""
        if isinstance(data, list):
            spi.write(data)  # Envia os bytes pela SPI
        else:
            raise TypeError("Os dados devem ser uma lista de bytes")

    def spi_read(self, num_bytes):
        """Lê uma quantidade específica de bytes pela SPI."""
        if isinstance(num_bytes, int) and num_bytes > 0:
            return spi.read(num_bytes)  # Lê o número de bytes especificado
        else:
            raise ValueError("Número de bytes a ser lido deve ser um inteiro positivo")
    def end(self):
        spi.freedev()

def main():

    try:
        # Inicializa a comunicação SPI
        spi_comm = SPI_Communication(SPI_DEV)

        data_received = spi_comm.spi_read(1)
        data_to_send = [0x6a]

        time.sleep(0.1)

        spi_comm.spi_send(data_to_send)

        print(f"Dados recebidos: {data_received}")

        print(f"Dados enviados: {data_to_send}")
        del spi_comm

    except Exception as e:
        logging.error(f"Erro: {e}")
if __name__ == '__main__':
    main()