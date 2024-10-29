# Optimización de Tarifas y Aterrizaje de Aviones

## Descripción

Este proyecto es una práctica de **programación lineal** centrada en la optimización de tarifas y gestión de aterrizaje de aviones mediante el uso de herramientas de modelado y solución matemática. Se plantea una solución en tres partes: 

1. **Optimización de Tarifas**: Maximización del beneficio al asignar tarifas a los asientos en cada avión, teniendo en cuenta las capacidades de peso y asiento.
2. **Gestión de Aterrizaje**: Minimización de los costes de retraso al asignar slots de aterrizaje dentro de los límites de tiempo de llegada y disponibilidad de las pistas.
3. **Modelo Fusionado**: Combinación de los modelos de tarifas y aterrizaje en un único modelo, optimizando ambas funciones objetivo.

## Estructura del Proyecto

- `parte-1/`: Incluye la modelización básica del problema de tarifas en LibreOffice Calc y su implementación en GLPK.
- `parte-2/`: Desarrollo del problema de gestión de slots de aterrizaje y restricciones de tiempo en GLPK.
- `parte-3/`: Modelo fusionado que combina la optimización de tarifas y la gestión de aterrizaje en un solo modelo GLPK.
- `data/`: Archivos `.dat` que contienen los datos utilizados en cada modelo.
- `models/`: Archivos `.mod` que definen los modelos en MathProg.
- `sol/`: Archivos de salida con las soluciones obtenidas en GLPK.

## Instalación y Requisitos

Para ejecutar los modelos, necesitarás:

- **GLPK** (GNU Linear Programming Kit)
- **LibreOffice Calc** (para la primera parte en Calc)
- **GLPSOL** (solucionador de GLPK) que puede ejecutarse con el comando `glpsol`.

### Ejecución de Modelos en GLPK

Para resolver el modelo de cualquier parte, ejecuta el siguiente comando en la terminal, ajustando los nombres de los archivos según corresponda:

```bash
glpsol -m parte-X/parte-X.mod -d parte-X/parte-X.dat -o parte-X/parte-X.sol
```
