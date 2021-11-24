class Mision {

	var peligrosidad
	const habilidadesNecesariasParaSerSuperada

	method sePuedeSuperarCon(unConjuntoDeHabilidades) {
		return habilidadesNecesariasParaSerSuperada.all({ habilidad => unConjuntoDeHabilidades.contains(habilidad) })
	}

	method fueSuperadaPor(alguien) {
		alguien.recibirDanio(peligrosidad)
		alguien.superarMision(self)
	}

	method habilidadesNecesariasQueLeFaltanA(alguien) {
		return habilidadesNecesariasParaSerSuperada.filter({ habilidad => alguien.tieneLaHabilidad(habilidad).negate() })
	}

}

