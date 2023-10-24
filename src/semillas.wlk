class Planta{
   const anio
   var property altura
      
   method horasSol()
   
   method esFuerte() = self.horasSol() > 10
   
   method nuevasSemillas() =
   	  return self.esFuerte() || self.adicional()
     
   method seAsociaBien(parcela) = 
   	   return parcela.criterioAsociacion(self)
  
	method adicional() 
}

class Menta inherits Planta{

	override method horasSol()= 6
	
	override method adicional() = altura > 0.4
	
	method espacio()= altura*3
	
	method parcelaIdeal(parcela) = 
		parcela.superficie() > 6
}

class Soja inherits Planta{
	override method horasSol() = 
		if(altura < 0.5)
			 6
		else if(altura >= 0.5 && altura < 1)
			 7
		else
			 9
		
	
	override method adicional()= anio > 2007 && altura > 1
	
	method espacio() = altura/2
	
	method parcelaIdeal(parcela) =
		parcela.horasSol() == self.horasSol()
}

class Quinoa inherits Planta{
	var property horasSol
	
	override method adicional() = anio < 2005
	
	method parcelaIdeal(parcela){
		return parcela.plantas().all({planta => planta.altura() <= 1.5})
	}
	method espacio() = 0.5
}

class SojaTransgenica inherits Soja{
	override method nuevasSemillas() = false
	
	override method parcelaIdeal(parcela)=
		parcela.maximasPlantas() == 1
}

class Hierbabuena inherits Menta{
	override method espacio() = super()*2
}

class Parcela{
	var ancho
	var largo
	var horasSol
	var plantas
	
	
	method cantPlantas() = plantas.size()
	method superficie() = ancho*largo
	
	method maximasPlantas() =
		if(ancho > largo){
			self.superficie()/5
		}else{
			self.superficie()/3 + largo
		}

     method porcentajePlantasBienAsociadas(parcela)
		= (plantas.count({planta => planta.seAsociaBien(parcela)})/plantas.size())*100
	
	method complicaciones() =
		plantas.any({planta => planta.horasSol() < horasSol})
	
	method plantar(planta){
		if(self.maximasPlantas() < (plantas.size() + 1))
			throw new DomainException (message = "falta de espacio") 
		if(horasSol >= planta.horasSol() + 2)
			throw new DomainException (message = "insuficiente sol")
		
		plantas.add(planta)

	}
}

class ParcelaEcologica inherits Parcela{
	method criterioAsociacion(planta) =
		not self.complicaciones() && planta.parcelaIdeal(self)
}

class ParcelaIndustrial inherits Parcela{
	method criterioAsociacion(planta) =
		self.maximasPlantas() == 2 && planta.esFuerte()
}

object inta{
	
	const parcelas = []
	
	method promedioPlantas() =
		parcelas.sum({parcela => parcela.cantPlantas()})/parcelas.size()

    method masCuatroPlantas() = parcelas.filter({parcela => parcela.cantPlantas()>4})
	
	method parcelaMasAutosustentable()
		= self.masCuatroPlantas().max({parcela => parcela.porcentajePlantasBienAsociadas()})

}


