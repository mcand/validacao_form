class @UIMask
	constructor: () ->
	@setMasks: () ->
		$('input[cda-data-type="cpf"]').setMask('999.999.999-99')
		$('input[cda-data-type="cep"]').setMask('99999-999')
		$('input[cda-data-type="cnpj"]').setMask('99.999.999/9999-99')
		$('input[cda-data-type="phone"]').setMask('(99) 9999-9999')
		$('input[cda-data-type="mobile"]').setMask('(99) *9999-9999')
		$('input[cda-data-type="date"]').setMask('39/19/9999')


