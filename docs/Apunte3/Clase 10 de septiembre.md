
# Diseñar feedback que permita decidir y continuar
Al terminar podras describir, diseñar y probar al menos cinco estados de una misma pantalla tanto en figma como en codigo

1. Vlidacion: Explicar que campo requiere atencion y como corregirlo
2. Carga: Dejar claro que la accion esta en proceso y evitar el doble envio
3. Error: Explica que paso y ofrecer una salida util
4. Exito y vacio: Confirmar el resultado y guiar el siguiente paso.
   

# 
1. Validacion: que debo corregir?
	Se conecta al campo y usa un mensaje especifico: "Ingresa un monto mayor"
2. Carga: Que esta pasando?
3. Exito: que ocurrió?
4. Vacio: Como empiezo?

### El mensaje no decora el estado: orienta la proxima decision.



# La Validacion debe aparecer cerca del problema y decir como resolverlo

1. No suficiente
	El borde rojo sin texto, un aviso al inicio de la pagina o "Error Invalido" obligan a adivinar que ocurrio
2. Util
	Etiqueta


# "Guardar" tambien tiene un antes, un durante y un despues.
El estado cambia cuando cambian los datos o el sistema. Diseñen ambos momentos.

1. Mientras procesa
- Cambia el texto a "Guardando..." o mostrar progreso

1. Cuando termina
- Exito: Confirmar que se guardo y ofrecer continuar o ver resultado.
- Error del sistema: Explicar


