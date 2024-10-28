# Conjuntos
set AVIONES;
set SLOTS;
set PISTAS;

# Parámetros
param coste{i in AVIONES};
param llegada{i in AVIONES};
param limite{i in AVIONES};
param inicio{j in SLOTS};
param disponibilidad{j in SLOTS, k in PISTAS};  # Matriz de disponibilidad

# Subconjunto de slots válidos para cada avión
set SLOTS_VALIDOS{i in AVIONES} within SLOTS :=
    {j in SLOTS : inicio[j] >= llegada[i] and inicio[j] <= limite[i]};

# Variables de decisión
var x{i in AVIONES, j in SLOTS, k in PISTAS}, binary;

# Función objetivo
minimize Coste_Retardo:
    sum{i in AVIONES, j in SLOTS_VALIDOS[i], k in PISTAS}
        coste[i] * (inicio[j] - llegada[i]) * x[i, j, k];

# Restricciones
#Restricción 1: Cada avión debe tener asignado un slot
s.t. Asignacion_Slot{i in AVIONES}:
    sum{j in SLOTS_VALIDOS[i], k in PISTAS} x[i, j, k] = 1;

#Restricción 2: Un slot solo puede estar asignado a un avión
s.t. Slot_Unico{j in SLOTS, k in PISTAS}:
    sum{i in AVIONES} x[i, j, k] <= 1;

#Restricción 3 Solo se asignan aviones a slots disponibles
s.t. Disponibilidad_Slot{i in AVIONES, j in SLOTS_VALIDOS[i], k in PISTAS}:
    x[i, j, k] <= disponibilidad[j, k];

#Restricción 4 Restricción de consecutividad de slots para cada avión y pista
s.t. No_Aterr_Consec{i in AVIONES, j in SLOTS_VALIDOS[i], k in PISTAS: j < 6}:
    x[i, j, k] + x[i, j+1, k] <= 1;
