class EnviadoAMisiones {

	method cumplirMision(unaMision) {
		if (self.puedeSuperar(unaMision)) {
			unaMision.fueSuperadaPor(self)
		} else {
			throw new Exception(message = "no se puede superar la mision")
		}
	}

	method puedeSuperar(unaMision)

}

class Empleado inherits EnviadoAMisiones {

	const property habilidades
	var salud
	var estaCapacitado = true
	var puesto
	const property misionesCompletadas

	method estaIncapacitado() {
		return not estaCapacitado
	}

	method puedeUsar(unaHabilidad) {
		return estaCapacitado and self.tieneLaHabilidad(unaHabilidad)
	}

	method tieneLaHabilidad(unaHabilidad) {
		return self.habilidades().contains(unaHabilidad)
	}

	override method puedeSuperar(unaMision) {
		return estaCapacitado and self.tieneLasHabilidadesNecesariasParaSuperar(unaMision)
	}

	method tieneLasHabilidadesNecesariasParaSuperar(unaMision) {
		return unaMision.sePuedeSuperarCon(self.habilidades())
	}

	method recibirDanio(danioRecibido) {
		salud -= danioRecibido
		if (salud < puesto.saludCritica()) {
			self.incapacitate()
		}
	}

	method incapacitate() {
		estaCapacitado = false
	}

	method superarMision(unaMision) {
		if (self.estaVivo()) {
			puesto.registrarMisionCompletada(self, unaMision)
			self.agregarAMisionesCompleatadas(unaMision)
		}
	}

	method estaVivo() {
		return salud > 0
	}

	method convertiteEnEspia() {
		puesto = espia
	}

	method agregarAMisionesCompleatadas(unaMision) {
		misionesCompletadas.add(unaMision)
	}

	method agregarHabilidadesQueNoConociaAntesDeCompletar(unaMision) {
		habilidades.addAll(unaMision.habilidadesNecesariasQueLeFaltanA(self))
	}

	method esEspia() {
		return puesto == espia
	}

}

class Jefe inherits Empleado {

	const subordinados

	override method puedeUsar(unaHabilidad) {
		return super(unaHabilidad) or self.algunSubordinadoPuedeUsar(unaHabilidad)
	}

	method algunSubordinadoPuedeUsar(unaHabilidad) {
		return subordinados.any({ subordinado => subordinado.puedeUsar(unaHabilidad) })
	}

}

class EquipoDeEmpleados inherits EnviadoAMisiones {

	const integrantes

	override method puedeSuperar(unaMision) {
		return unaMision.sePuedeSuperarCon(self.habilidadesTotales())
	}

	method habilidadesTotales() {
		return self.integrantesCapacitados().flatMap({ integrante => integrante.habilidades() })
	}

	method integrantesCapacitados() {
		return integrantes.filter({ integrante => integrante.estaIncapacitado().negate() })
	}

	method puedeUsar(unaHabilidad) {
		return integrantes.any({ integrante => integrante.puedeUsar(unaHabilidad) })
	}

	method recibirDanio(danioRecibido) {
		integrantes.forEach({ integrante => integrante.recibirDanio(danioRecibido.div(3))})
	}

	method superarMision(unaMision) {
		integrantes.forEach({ integrante => integrante.superarMision(unaMision)})
	}

}

object espia {

	method saludCritica() {
		return 15
	}

	method registrarMisionCompletada(unEmpleado, unaMision) {
		unEmpleado.agregarHabilidadesQueNoConociaAntesDeCompletar(unaMision)
	}

}

object oficinista {

	var estrellas = 0

	method saludCritica() {
		return 40 - 5 * estrellas
	}

	method registrarMisionCompletada(unEmpleado, _unaMision) {
		estrellas += 1
		if (estrellas == 3) {
			unEmpleado.convertiteEnEspia()
		}
	}

}

