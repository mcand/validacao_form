emailRegEx = new RegExp(/^((?!\.)[a-z0-9._%+-]+(?!\.)\w)@[a-z0-9-]+\.[a-z.]{1,5}(?!\.)\w$/i)
emptyRegEx = new RegExp(/[-_.a-zA-Z0-9]{3,}/)
numberRegEx = new RegExp(/^[0-9]{1,}$/)
postalCodeRegEx = new RegExp(/^\d{5}-\d{3}$/)

class @UIValidation
  @dateIsValid: (e) ->
    currVal = $(e).val()
    return false  if currVal is ""
    rxDatePattern = /^(\d{1,2})(\/|-)(\d{1,2})(\/|-)(\d{4})$/ #Declare Regex
    dtArray = currVal.match(rxDatePattern) # is format OK?
    return false  unless dtArray?
    
    dtMonth = dtArray[3]
    dtDay = dtArray[1]
    dtYear = dtArray[5]

    dtMonth = parseInt(dtMonth)
    dtDay = parseInt(dtDay)
    dtYear = parseInt(dtYear)

    if dtMonth < 1 or dtMonth > 12
      return false
    else if dtDay < 1 or dtDay > 31
      return false
    else if (dtMonth is 4 or dtMonth is 6 or dtMonth is 9 or dtMonth is 11) and dtDay is 31
      return false
    else if dtMonth is 2
      isleap = (dtYear % 4 == 0 and (dtYear % 100 isnt 0 or dtYear % 400 == 0))
      return false  if dtDay > 29 or (dtDay == 29 and not isleap)
    true
  @cnpjIsValid: (e) ->
    cnpj = $(e).val().replace(/[^\d]+/g, "")
    return false  if cnpj is ""
    return false  unless cnpj.length is 14
  
    # Elimina CNPJs invalidos conhecidos
    return false  if cnpj is "00000000000000" or cnpj is "11111111111111" or cnpj is "22222222222222" or cnpj is "33333333333333" or cnpj is "44444444444444" or cnpj is "55555555555555" or cnpj is "66666666666666" or cnpj is "77777777777777" or cnpj is "88888888888888" or cnpj is "99999999999999"
  
    # Valida DVs
    tamanho = cnpj.length - 2
    numeros = cnpj.substring(0, tamanho)
    digitos = cnpj.substring(tamanho)
    soma = 0
    pos = tamanho - 7
    i = tamanho
    while i >= 1
      soma += numeros.charAt(tamanho - i) * pos--
      pos = 9  if pos < 2
      i--
    resultado = (if soma % 11 < 2 then 0 else 11 - soma % 11)
    return false  unless resultado is digitos.charAt(0)
    tamanho = tamanho + 1
    numeros = cnpj.substring(0, tamanho)
    soma = 0
    pos = tamanho - 7
    i = tamanho
    while i >= 1
      soma += numeros.charAt(tamanho - i) * pos--
      pos = 9  if pos < 2
      i--
    resultado = (if soma % 11 < 2 then 0 else 11 - soma % 11)
    return false  unless resultado is digitos.charAt(1)
    true
  @cpfIsValid: (e) ->
    cpf = $(e).val().replace(/[^\d]+/g, "")
    return false  if cpf is ""

    # Elimina CPFs invalidos conhecidos
    return false  if cpf.length isnt 11 or cpf is "00000000000" or cpf is "11111111111" or cpf is "22222222222" or cpf is "33333333333" or cpf is "44444444444" or cpf is "55555555555" or cpf is "66666666666" or cpf is "77777777777" or cpf is "88888888888" or cpf is "99999999999"

    # Valida 1o digito
    add = 0
    i = 0
    while i < 9
      add += parseInt(cpf.charAt(i)) * (10 - i)
      i++
    rev = 11 - (add % 11)
    rev = 0  if rev is 10 or rev is 11
    return false  unless rev is parseInt(cpf.charAt(9))

    # Valida 2o digito
    add = 0
    i = 0
    while i < 10
      add += parseInt(cpf.charAt(i)) * (11 - i)
      i++
    rev = 11 - (add % 11)
    rev = 0  if rev is 10 or rev is 11
    return false  unless rev is parseInt(cpf.charAt(10))
    true    
  @types:
    invalidFormat: 'invalidFormat'
    required: 'required'
    confirmation: 'confirmation'

  @customValidations:{}
  @addCustomValidation: (e, method) ->
    @customValidations[e] = [] unless $.isArray(@customValidations[e])
    @customValidations[e].push(method)

  @validate: 
    date: (e) ->
      unless UIValidation.dateIsValid(e)
        return UIValidation.types.invalidFormat
    email: (e) ->
      unless emailRegEx.test($(e).val())
        return UIValidation.types.invalidFormat
    cpf: (e) ->
      unless UIValidation.cpfIsValid(e)
        return UIValidation.types.invalidFormat   
    cnpj: (e) ->
      unless UIValidation.cnpjIsValid(e)
        return UIValidation.types.invalidFormat
    cep: (e) ->
      unless postalCodeRegEx.test($(e).val())
        return UIValidation.types.invalidFormat
    number: (e) ->
      unless numberRegEx.test($(e).val())
        return UIValidation.types.invalidFormat
    confirmation: (mainField, confirmationField) ->
      unless $(mainField).val() == $(confirmationField).val()
        return UIValidation.types.confirmation
  constructor: () ->
  @setValidations: ->
    $(":input").blur ->
      errors = []
      parent = UIValidation.fieldParent(@)
      if parent.hasClass("required") and !$(@).val()
        errors.push(UIValidation.types.required) 
      else
        errors.push(UIValidation.validate[$(@).attr('cda-data-type')]?(@))

        # Compara o valor com o campo de confirmação, caso possua
        confirmationField = $('#' + $(@).attr('cda-confirmation-field'))
        errors.push(UIValidation.validate.confirmation(@, confirmationField)) if confirmationField.size() > 0

        # Se o campo atual for um campo de confirmação, aciona evento de validação do campo principal
        $(':input[cda-confirmation-field=' + @.id + ']').blur()

        if $.isArray(UIValidation.customValidations[@])
          for method in UIValidation.customValidations[@]
            try 
              errors.push(method.call(@, errors)) if $.isFunction(method)
      UIValidation.setMessageToErrorField(@, errors)
  @setMessageToErrorField: (e, errors) ->
    errors = @filterErrors(errors)
    parent = @fieldParent(e)
    @clearMessage(e)
    message_error = "#{errors.join(',')}"
    parent.addClass("field_with_errors").append($("<span>").addClass("error").text(message_error)) if errors.length > 0
  @fieldParent: (field) ->
    $(field).parents('.input')
  @clearMessage: (field) ->
    parent = @fieldParent(field)
    parent.removeClass("field_with_errors").find('span').remove()
  @filterErrors: (errors) -> 
    (error for error in errors when error isnt undefined)
