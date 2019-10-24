I18n.translations || (I18n.translations = {});
I18n.translations["es"] = I18n.extend((I18n.translations["es"] || {}), {"activerecord":{"attributes":{"brand":{"name":"Marca"},"client":{"address":"Dirección","name":"Cliente","nit":"Nit","phone":"Teléfono"},"material":{"code":"Código","description":"Descripción","name":"Material"},"measure_unit":{"name":"Unidad de Medida","unit_type":"Tipo de medida"},"price":{"brand_id":"Marca","material_id":"Material","measure_unit_id":"Unidad de Medida","product_price":"Precio"},"product":{"brand_id":"Marca","code":"Código","material_id":"Material","measure_unit_id":"Unidad de Medida","product_price":"Precio"},"quotation":{"client":"Cliente","state":"Estado"},"service":{"description":"Descripción","name":"Servicio","price":"Precio"},"user":{"avatar":"Foto de Perfil","confirmation_sent_at":"Confirmación enviada a","confirmation_token":"Código de confirmación","confirmed_at":"Confirmado en","created_at":"Creado en","current_password":"Contraseña actual","current_sign_in_at":"Fecha del ingreso actual","current_sign_in_ip":"IP del ingreso actual","email":"Correo Electrónico","encrypted_password":"Contraseña cifrada","failed_attempts":"Intentos fallidos","last_sign_in_at":"Fecha del último ingreso","last_sign_in_ip":"IP del último inicio","locked_at":"Fecha de bloqueo","password":"Contraseña","password_confirmation":"Confirmar Contraseña","remember_created_at":"Fecha de 'Recordarme'","remember_me":"Recordarme","reset_password_sent_at":"Fecha de envío de código para contraseña","reset_password_token":"Código para restablecer contraseña","role":"Rol","sign_in_count":"Cantidad de ingresos","unconfirmed_email":"Email no confirmado","unlock_token":"Código de desbloqueo","updated_at":"Actualizado en"},"user_detail":{"last_name":"Apellido(s)","name":"Nombre(s)","phone":"Teléfono"}},"errors":{"messages":{"record_invalid":"La validación falló: %{errors}","restrict_dependent_destroy":{"has_many":"No se puede eliminar el registro porque existen %{record} dependientes","has_one":"No se puede eliminar el registro porque existe un %{record} dependiente"}},"models":{"brand":{"attributes":{"name":{"duplicated":"La marca ya se encuentra registrada."}}},"client":{"attributes":{"name":{"duplicated":"ya se encuentra registrado."},"nit":{"duplicated":"ya se encuentra registrado."}}},"measure_unit":{"attributes":{"name":{"duplicated":"La unidad ya se encuentra registrada."}}},"quotation":{"attributes":{"state":{"activation_impossible":"no permite la activación de la cotización","destroy_impossible":"no permite la eliminación de la cotización"}}},"service":{"attributes":{"name":{"duplicated":"ya se encuentra registrado."}}},"user":{"attributes":{"avatar":{"invalid_file_type":"El archivo seleccionado no es una imagen"},"role":{"does_not_exist":"El rol seleccionado no existe"}}}}},"models":{"brand":"Marca","client":"Cliente","material":"Material","measure_unit":"Unidad de medida","price":"Precio","product":"Precio","quotation":"Cotización","service":"Servicio","user":"Usuario","user_detail":"Detalle del Usuario"}},"application":{"title":"Cotizador de Proyectos"},"attachments":{"error":"error","no_save":"No se pudo guardar el archivo","no_user":"No es el usuario que agrego el archivo"},"brands":{"cancel":"Cancelar","create":{"success":"La marca %{name} ha sido creada satisfactoriamente."},"destroy":{"destroy":"La marca %{name} ha sido eliminada satisfactoriamente."},"edit":{"edit_brand":"Editar Marca"},"index":{"delete_modal":{"body":"Una vez eliminada no podrás recuperarla y deberás crear una nueva. Todas la información asociada a esta marca (productos, cotizaciones, etc.) seguirá existiendo.","no_text":"Cancelar","title":"¿Realmente deseas eliminiar a esta marca?","yes_text":"Sí, elimínala"},"name":"Nombre","new":"Nueva Marca","no_results_found":"No hay resultados para mostrar.","page_size_placeholder":"Filas por página","search_name":"Nombre de la marca","search_title":"Filtrar por","tooltip":{"delete_brand":"Eliminar esta marca","edit_brand":"Editar esta marca"}},"new":{"new_brand":"Nueva Marca"},"return":"Regresar","save":"Guardar","search":"Buscar","title":"Marcas","update":{"update":"La marca %{name} ha sido actualizada satisfactoriamente."}},"clients":{"create":{"success":"El cliente ha sido creado satisfactoriamente."},"destroy":{"destroy":"El cliente ha sido eliminado satisfactoriamente."},"edit":{"edit_client":"Editar Cliente"},"index":{"address":"Dirección","delete_modal":{"body":"Una vez eliminado no podrás recuperarlo y deberás crear uno nuevo. Todas las cotizaciones asociadas a este cliente seguirán existiendo.","no_text":"Cancelar","title":"¿Realmente deseas eliminar a este cliente?","yes_text":"Sí, elimínalo"},"name":"Nombre","new":"Nuevo Cliente","nit":"Nit","no_results_found":"No hay resultados para mostrar.","page_size_placeholder":"Filas por página","phone":"Teléfono","search_name":"Nombre del cliente","search_title":"Filtrar por","tooltip":{"delete_brand":"Eliminar este cliente","edit_brand":"Editar este cliente"}},"new":{"new_client":"Nuevo Cliente"},"return":"Regresar","save":"Guardar","search":"Buscar","title":"Clientes","title_singular":"Cliente","update":{"update":"El cliente ha sido actualizado satisfactoriamente."}},"comments":{"create":{"error":"error","no_save":"No se puede agregar el comentario"},"destroy":{"error":"error","no_delete":"No se pudo eliminar el comentario"},"update":{"error":"error","no_user":"No se permite actualizar un comentario que no haz creado"}},"currency":"GTQ","dashboards":{"index":{"headers_dashboard":{"actions":"","id":"Código","name":"Cliente","quotation_date":"Fecha","quotation_type":"Tipo","state":"Estado"},"page_size_placeholder":"Filas por página","state_accepted":"Aprobada por el Cliente","state_active":"Activa","state_created":"Creada","state_expired":"Expirada"},"states":{"accepted":"Aprobada por el Cliente","active":"Activa","created":"Creada","expired":"Expirada"},"title":"Panel de Cotizaciones","title_nav":"Inicio"},"date":"Fecha","datetime":{"distance_in_words":{"about_x_hours":{"one":"alrededor de 1 hora","other":"alrededor de %{count} horas"},"about_x_months":{"one":"alrededor de 1 mes","other":"alrededor de %{count} meses"},"about_x_years":{"one":"alrededor de 1 año","other":"alrededor de %{count} años"},"almost_x_years":{"one":"casi 1 año","other":"casi %{count} años"},"half_a_minute":"medio minuto","less_than_x_minutes":{"one":"menos de 1 minuto","other":"menos de %{count} minutos"},"less_than_x_seconds":{"one":"menos de 1 segundo","other":"menos de %{count} segundos"},"over_x_years":{"one":"más de 1 año","other":"más de %{count} años"},"x_days":{"one":"1 día","other":"%{count} días"},"x_minutes":{"one":"1 minuto","other":"%{count} minutos"},"x_months":{"one":"1 mes","other":"%{count} meses"},"x_seconds":{"one":"1 segundo","other":"%{count} segundos"},"x_years":{"one":"1 año","other":"%{count} años"}},"prompts":{"day":"Día","hour":"Hora","minute":"Minuto","month":"Mes","second":"Segundo","year":"Año"}},"devise":{"confirmations":{"confirmed":"Tu cuenta ha sido confirmada satisfactoriamente.","new":{"resend_confirmation_instructions":"Reenviar instrucciones de confirmación"},"send_instructions":"Vas a recibir un correo con instrucciones sobre cómo confirmar tu cuenta en unos minutos.","send_paranoid_instructions":"Si tu correo existe en nuestra base de datos, en unos minutos recibirás un correo con instrucciones sobre cómo confirmar tu cuenta."},"failure":{"already_authenticated":"Ya has iniciado sesión.","inactive":"Tu cuenta aún no ha sido activada.","invalid":"%{authentication_keys} o contraseña inválidos.","last_attempt":"Tienes un intento más antes de que tu cuenta sea bloqueada.","locked":"Tu cuenta está bloqueada.","not_found_in_database":"%{authentication_keys} o contraseña inválidos.","timeout":"Tu sesión expiró. Por favor, inicia sesión nuevamente para continuar.","unauthenticated":"Tienes que iniciar sesión o registrarte para poder continuar.","unconfirmed":"Tienes que confirmar tu cuenta para poder continuar."},"mailer":{"confirmation_instructions":{"action":"Confirmar mi cuenta","greeting":"¡Bienvenido %{recipient}!","instruction":"Usted puede confirmar el correo electrónico de su cuenta a través de este enlace:","subject":"Instrucciones de confirmación"},"email_changed":{"greeting":"¡Hola %{recipient}! ","message":"Estamos contactando contigo para notificarte que tu email ha sido cambiado a %{email}.","subject":"Email cambiado"},"password_change":{"greeting":"Hola %{recipient}!","message":"Le estamos contactando para notificarle que su contraseña ha sido cambiada.","subject":"Contraseña cambiada"},"reset_password_instructions":{"action":"Cambiar mi contraseña","greeting":"¡Hola %{name}!","instruction":"Alguien ha solicitado un enlace para cambiar su contraseña, puedes acceder a el a través del siguiente enlace.","instruction_2":"Si usted no lo ha solicitado, por favor ignore este correo electrónico.","instruction_3":"Su contraseña no será cambiada hasta que usted acceda al enlace y cree una nueva.","subject":"Instrucciones de recuperación de contraseña"},"unlock_instructions":{"action":"Desbloquear mi cuenta","greeting":"¡Hola %{recipient}!","instruction":"Haga click en el siguiente enlace para desbloquear su cuenta:","message":"Su cuenta ha sido bloqueada debido a una cantidad excesiva de intentos infructuosos para ingresar.","subject":"Instrucciones para desbloquear"}},"omniauth_callbacks":{"failure":"No has sido autorizado en la cuenta %{kind} porque \"%{reason}\".","success":"Has sido autorizado satisfactoriamente en la cuenta %{kind}."},"passwords":{"edit":{"change_my_password":"Cambiar mi contraseña","change_your_password":"Cambie su contraseña","confirm_new_password":"Confirme la nueva contraseña","new_password":"Nueva contraseña"},"new":{"forgot_your_password":"¿Ha olvidado su contraseña?","send_me_reset_password_instructions":"Envíeme las instrucciones para resetear mi contraseña"},"no_token":"No puedes acceder a esta página si no es a través de un enlace para resetear tu contraseña. Si has llegado hasta aquí desde el email para resetear tu contraseña, por favor asegúrate de que la URL introducida está completa.","send_instructions":"Recibirás un correo con instrucciones sobre cómo resetear tu contraseña en unos pocos minutos.","send_paranoid_instructions":"Si tu correo existe en nuestra base de datos, recibirás un correo con instrucciones sobre cómo resetear tu contraseña en tu bandeja de entrada.","updated":"Se ha cambiado tu contraseña. Ya iniciaste sesión.","updated_not_active":"Tu contraseña fue cambiada."},"registrations":{"destroyed":"¡Adiós! Tu cuenta ha sido cancelada correctamente. Esperamos verte pronto.","edit":{"are_you_sure":"¿Está usted seguro?","cancel_my_account":"Anular mi cuenta","currently_waiting_confirmation_for_email":"Actualmente esperando la confirmacion de: %{email} ","leave_blank_if_you_don_t_want_to_change_it":"dejar en blanco si no desea cambiarla","title":"Editar %{resource}","unhappy":"¿Disconforme?","update":"Actualizar","we_need_your_current_password_to_confirm_your_changes":"necesitamos su contraseña actual para confirmar los cambios"},"new":{"sign_up":"Registrarse"},"signed_up":"Bienvenido. Tu cuenta fue creada.","signed_up_but_inactive":"Tu cuenta ha sido creada correctamente. Sin embargo, no hemos podido iniciar la sesión porque tu cuenta aún no está activada.","signed_up_but_locked":"Tu cuenta ha sido creada correctamente. Sin embargo, no hemos podido iniciar la sesión porque que tu cuenta está bloqueada.","signed_up_but_unconfirmed":"Se ha enviado un mensaje con un enlace de confirmación a tu correo electrónico. Abre el enlace para activar tu cuenta.","update_needs_confirmation":"Has actualizado tu cuenta correctamente, pero es necesario confirmar tu nuevo correo electrónico. Por favor, comprueba tu correo y sigue el enlace de confirmación para finalizar la comprobación del nuevo correo electrónico.","updated":"Tu cuenta se ha actualizado.","updated_but_not_signed_in":"Su cuenta se ha actualizado correctamente, pero como se cambió su contraseña, debe iniciar sesión nuevamente"},"sessions":{"already_signed_out":"Sesión finalizada.","new":{"sign_in":"Iniciar sesión"},"signed_in":"Sesión iniciada.","signed_out":"Sesión finalizada."},"shared":{"links":{"back":"Atrás","didn_t_receive_confirmation_instructions":"¿No ha recibido las instrucciones de confirmación?","didn_t_receive_unlock_instructions":"¿No ha recibido instrucciones para desbloquear?","forgot_your_password":"¿Ha olvidado su contraseña?","sign_in":"Iniciar sesión","sign_in_with_provider":"Iniciar sesión con %{provider}","sign_up":"Registrarse"},"minimum_password_length":{"one":"(%{count} caractere como mínimo)","other":"(%{count} caracteres como mínimo)"}},"unlocks":{"new":{"resend_unlock_instructions":"Reenviar instrucciones para desbloquear"},"send_instructions":"Vas a recibir instrucciones para desbloquear tu cuenta en unos pocos minutos.","send_paranoid_instructions":"Si tu cuenta existe, vas a recibir instrucciones para desbloquear tu cuenta en unos pocos minutos.","unlocked":"Tu cuenta ha sido desbloqueada. Ya puedes iniciar sesión."}},"errors":{"format":"%{attribute} %{message}","messages":{"accepted":"debe ser aceptado","already_confirmed":"ya ha sido confirmada, por favor intenta iniciar sesión","blank":"no puede estar en blanco","confirmation":"no coincide","confirmation_period_expired":"necesita confirmarse dentro de %{period}, por favor solicita una nueva","empty":"no puede estar vacío","equal_to":"debe ser igual a %{count}","even":"debe ser par","exclusion":"está reservado","expired":"ha expirado, por favor solicita una nueva","greater_than":"debe ser mayor que %{count}","greater_than_or_equal_to":"debe ser mayor que o igual a %{count}","inclusion":"no está incluido en la lista","invalid":"no es válido","less_than":"debe ser menor que %{count}","less_than_or_equal_to":"debe ser menor que o igual a %{count}","model_invalid":"La validación falló: %{errors}","not_a_number":"no es un número","not_an_integer":"debe ser un entero","not_found":"no se ha encontrado","not_locked":"no estaba bloqueada","not_saved":{"one":"Ocurrió un error al tratar de guardar %{resource}:","other":"Ocurrieron %{count} errores al tratar de guardar %{resource}:"},"odd":"debe ser impar","other_than":"debe ser distinto de %{count}","present":"debe estar en blanco","required":"debe existir","taken":"ya está en uso","too_long":{"one":"es demasiado largo (1 carácter máximo)","other":"es demasiado largo (%{count} caracteres máximo)"},"too_short":{"one":"es demasiado corto (1 carácter mínimo)","other":"es demasiado corto (%{count} caracteres mínimo)"},"wrong_length":{"one":"no tiene la longitud correcta (1 carácter exactos)","other":"no tiene la longitud correcta (%{count} caracteres exactos)"}},"template":{"body":"Se encontraron problemas con los siguientes campos:","header":{"one":"No se pudo guardar este/a %{model} porque se encontró 1 error","other":"No se pudo guardar este/a %{model} porque se encontraron %{count} errores"}}},"formats":{"local_date":"%d/%m/%Y","standard_date":"%Y-%m-%d"},"helpers":{"page_entries_info":{"more_pages":{"display_entries":"Mostrando \u003cb\u003e%{first}\u0026nbsp;-\u0026nbsp;%{last}\u003c/b\u003e %{entry_name} de \u003cb\u003e%{total}\u003c/b\u003e en total"},"one_page":{"display_entries":{"one":"Mostrando \u003cb\u003e%{count}\u003c/b\u003e %{entry_name}","other":"Mostrando \u003cb\u003eun total de %{count}\u003c/b\u003e %{entry_name}","zero":"No se han encontrado %{entry_name}"}}},"select":{"prompt":"Por favor seleccione"},"submit":{"create":"Crear %{model}","submit":"Guardar %{model}","update":"Actualizar %{model}"}},"i18n":{"plural":{"keys":["one","other"],"rule":{}},"transliterate":{"rule":{"Á":"A","É":"E","Í":"I","Ñ":"N","Ó":"O","Ú":"U","Ü":"U","á":"a","é":"e","í":"i","ñ":"n","ó":"o","ú":"u","ü":"u"}}},"js_currency_locale":"es-GT","materials":{"create":{"success":"El material fue creado satisfactoriamente."},"destroy":{"destroy":"El material ha sido eliminada satisfactoriamente."},"edit":{"edit_material":"Editar Material"},"index":{"delete_modal":{"body":"Una vez eliminado no podrás recuperarlo y deberás crear uno nuevo. Toda las cotizaciones asociadas a este precio seguirán existiendo.","no_text":"Cancelar","title":"¿Realmente deseas eliminar este material?","yes_text":"Sí, elimínalo"},"description":"Descripción","name":"Nombre","new":"Nuevo Material","no_results_found":"No hay resultados para mostrar.","page_size_placeholder":"Filas por página","search_description":"Descripción del material","search_name":"Nombre del material","search_title":"Filtrar por","tooltip":{"delete_brand":"Eliminar este material","edit_brand":"Editar este material"}},"new":{"new_material":"Nuevo Material"},"return":"Regresar","save":"Guardar","search":"Buscar","title":"Materiales","update":{"update":"El material fue actualizado satisfactoriamente."}},"materials_parser":{"nofile":"No es un archivo permitido","noformat":"No utiliza el formato estandarizado"},"measure_units":{"create":{"success":"La unidad ha sido creada satisfactoriamente."},"destroy":{"destroy":"La unidad de medida ha sido eliminada satisfactoriamente."},"edit":{"edit_measure":"Editar Unidad de Medida"},"index":{"delete_modal":{"body":"Una vez eliminada no podrás recuperarla y deberás crear una nueva. Todas la información asociada a esta unidad de medida (productos, precios, etc.) seguirá existiendo.","no_text":"Cancelar","title":"¿Realmente deseas eliminiar a esta unidad de medida?","yes_text":"Sí, elimínala"},"name":"Unidad de Medida","new":"Nueva Unidad de Medida","no_results_found":"No hay resultados para mostrar.","page_size_placeholder":"Filas por página","search":"Buscar Unidad de Medida","search_name":"Nombre de la unidad de medida","search_title":"Filtrar por","tooltip":{"delete_brand":"Eliminar esta unidad de medida","edit_brand":"Editar esta unidad de medida"},"unit_type":"Tipo de Medida"},"new":{"new_measure":"Nueva Unidad de Medida"},"return":"Regresar","save":"Guardar","search":"Buscar","show":{"back":"Regresar","edit":"Editar"},"title":"Unidades de Medida","update":{"update":"La unidad de ha sido actualizada satisfactoriamente."}},"nofile":"No a seleccionado un archivo","noformat":"No utiliza el formato estandarizado","number":{"currency":{"format":{"delimiter":".","format":"%n %u","precision":2,"separator":",","significant":false,"strip_insignificant_zeros":false,"unit":"€"}},"format":{"delimiter":".","precision":3,"separator":",","significant":false,"strip_insignificant_zeros":false},"human":{"decimal_units":{"format":"%n %u","units":{"billion":"mil millones","million":{"one":"millón","other":"millones"},"quadrillion":"mil billones","thousand":"mil","trillion":{"one":"billón","other":"billones"},"unit":""}},"format":{"delimiter":"","precision":1,"significant":true,"strip_insignificant_zeros":true},"storage_units":{"format":"%n %u","units":{"byte":{"one":"Byte","other":"Bytes"},"eb":"EB","gb":"GB","kb":"KB","mb":"MB","pb":"PB","tb":"TB"}}},"percentage":{"format":{"delimiter":"","format":"%n %"}},"precision":{"format":{"delimiter":""}}},"password_reset_email":{"action":"Ingresa aquí","greeting":"¡Hola %{name}!","instruction":"Su contraseña ha sido reiniciada por un administrador. Por favor ingrese al portal del cotizador con el enlace de abajo y utlize la siguiente contraseña: ","instruction_2":"Una vez adentro, le recomendamos cambiar la contraseña por una de su preferencia.","instruction_3":"Si no esta al tanto de este reinicio, por favor comuniquese con uno de los administradores para mas información.","subject":"Su Contraseña ha sido Reiniciada"},"prices":{"brand":"Marca","code":"Código","dashboard":{"new_material_text":"Estos son los nuevos materiales","title":"Actualizados Recientemente"},"manager":"Administrar","material":"Material","price":"Precio","return":"Regresar","save":"Guardar","search":"Buscar","title":"Precios"},"products":{"api_get_by_material":{"errors":{"material_not_found":"No se encontro ningun material con el código especificado","unespecified_material":"No se especifico un material a buscar"}},"brand":"Marca","code":"Código","create":{"success":"El precio fue creado satisfactoriamente."},"dashboard":{"new_material_text":"Estos son los nuevos materiales","title":"Nuevos"},"destroy":{"destroy":"El precio ha sido eliminado satisfactoriamente."},"index":{"delete_modal":{"body":"Una vez eliminado no podrás recuperarlo y deberás crear uno nuevo. Todas la información asociada a este material (productos, cotizaciones, etc.) seguirá existiendo.","no_text":"Cancelar","title":"¿Realmente deseas eliminiar este precio?","yes_text":"Sí, elimínalo"},"measure_unit":"Unidad","new":"Nuevo Precio","no_results_found":"No hay resultados para mostrar.","page_size_placeholder":"Filas por página","search_title":"Filtrar por"},"manager":"Administrar","material":"Material","new_modal":{"import":"Importar","instruction1":"1) Seleccione el archivo que desea cargar.","instruction2":"2) De click en importar para cargar el archivo.","title":"Precios","upload":"Subir Excel"},"price":"Precio","return":"Regresar","save":"Guardar","search":"Buscar","title":"Precios","update":{"update":"El precio se actualizó satisfactoriamente."},"upload":{"upload":"Se ha importado el archivo y actualizado los precios."}},"quotations":{"api_types":{"t_comparative":"Comparativa","t_siemon_only":"Solo Siemon","t_simple":"Simple","t_supranet_only":"Solo Supranet"},"attachments":{"upload":"Por favor seleccione un archivo"},"create":{"error":"Ha ocurrido un error al crear la cotizacion"},"deleted_list":"Eliminadas","destroy":{"error":"Ha ocurrido un error al eliminar la cotización"},"index":{"brand":"Marca","buttons":{"new":"Nueva Cotización","search":"Buscar"},"date":"Fecha","delete_modal":{"body":"Una vez eliminado no podrás recuperarla y deberás crear una nueva. Solo las cotizaciónes en estados 'Creada' y 'Expirada' se pueden eliminar","no_text":"Cancelar","title":"¿Realmente deseas eliminar esta cotización?","yes_text":"Sí, elimínala"},"headers":{"actions":"","default_select_option":"Seleccione una opción de la lista","id":"Código","name":"Cliente","quotation_date":"Fecha","quotation_type":"Tipo","state":"Estado"},"name":"Cliente","notifications":{"quotation_deleted":"La cotización ha sido eliminada satisfactoriamente"},"page_size_placeholder":"Filas por página","search":"Buscar Cotización","search_fields":{"titles":{"code":"Código de la Cotización","date":"Fecha"}},"search_title":"Filtrar por","status":"Estado","title":"Cotizaciones"},"log":"Historial","manager":"Administración","new_edit":{"attachments_view":{"title":"Attachments"},"brands":{"siemon":"Siemon","supranet":"Supranet"},"buttons":{"approve_quotation":"Activar Cotización","discard_quotation":"Descartar","print_excel":"Imprimir Excel","print_pdf":"Imprimir PDF"},"conditions":{"next":"Siguiente","notifications":{"conditions_updated":"Cambios guardados en las condiciones"},"title":"Condiciones","titles":{"credits":"Créditos","payment_condition":"Términos y Condiciones de Pago","warranty":"Garantía"}},"discard_modal":{"body":"El número actualmente asignado a esta cotización no se podrá volver a usar, y  toda la información que has agregado hasta el momento (servicios, materiales, etc.) se perderá completamente.","no_text":"Cancelar","title":"¿Realmente deseas descartar esta cotización?","yes_text":"Si, descártala"},"edit_title":"Editar Cotización","global_view":{"title":"Vista Global"},"header":{"brands":{"use_siemon":"Usar Siemon","use_supranet":"Usar Supranet"},"errors":{"client":"Debe seleccionar un cliente","date":"Debe ingresar una fecha válida"},"next":"Siguiente","notifications":{"header_updated":"Cambios guardados en el encabezado"},"select_client":"Seleccione un cliente","service_percentage":"Holgura Servicios","title":"Datos Generales","titles":{"client":"Cliente","code":"Código","date":"Fecha","nit":"Nit","quotation_type":"Tipo Cotización"}},"materials":{"buttons":{"add_material":"Agregar","next":"Siguiente"},"custom_headers":{"expression":"Expresión en Quetzales (GTQ)","with_percentage":"Con Holgura","without_percentage":"Sin Holgura"},"headers":{"amount":"Cantidad","brand":"Marca","code":"Código","material":"Material","percent":"Holgura","percent_siemon":"Holgura","percent_supranet":"Holgura","price":"Unitario","price_percent":"Unitario","price_percent_siemon":"Unitario","price_percent_supranet":"Unitario","price_siemon":"Unitario","price_supranet":"Unitario","total":"Total","total_percent":"Total","total_percent_siemon":"Total","total_percent_supranet":"Total","total_siemon":"Total","total_supranet":"Total"},"notifications":{"materials_updated":"Cambios guardados en los materiales"},"select-material":"Seleccione un material","title":"Materiales","titles":{"amount":"Cantidad","material":"Material","percent":"Holgura","price":"Precio"}},"new_title":"Nueva Cotización","notifications":{"quotation_activated":"La cotización ha sido activada satisfactoriamente","quotation_discarded":"La cotización ha sido descartada satifactoriamente"},"services":{"buttons":{"add_service":"Agregar","next":"Siguiente"},"headers":{"actions":"","amount":"Cantidad","name":"Servicio","percent":"Holgura","price":"Precio","tot_with_perc":"Total con Holgura","tot_without_perc":"Total sin Holgura"},"notifications":{"services_updated":"Cambios guardados en los servicios"},"title":"Servicios","titles":{"amount":"Cantidad","percent":"Holgura","price":"Precio","service":"Servicio"}}},"show":{"brands":{"t_siemon_only":"Siemon","t_supranet_only":"Supranet"},"custom_footers":{"materials":"Materiales","not_used":"--"},"custom_headers":{"expression":"Expresión en Quetzales (GTQ)","prices":"Precios","total":"Total (GTQ)","with_percent":"Con Holgura","without_percent":"Sin Holgura"},"headers":{"amount":"Cantidad","brand":"Marca","material":"Descripción","percent":"Holgura","price":"Unitario","price_with_percent":"Unitario","service":"Descripción","t_siemon_only_percent":"Holgura","t_siemon_only_price":"Unitario","t_siemon_only_price_with_percent":"Unitario","t_siemon_only_total":"Total","t_siemon_only_total_with_percent":"Total","t_simple_price":"Unitario","t_simple_price_with_percent":"Unitario","t_simple_total":"Total","t_simple_total_with_percent":"Total","t_supranet_only_percent":"Holgura","t_supranet_only_price":"Unitario","t_supranet_only_price_with_percent":"Unitario","t_supranet_only_total":"Total","t_supranet_only_total_with_percent":"Total","total":"Total","total_with_percent":"Total"},"titles":{"client":{"address":"Dirección","client":"Cliente","info":"Datos del Cliente","nit":"Nit","phone":"Teléfono"},"credits":"Crédito","materials":"Detalle de Materiales","option_a":"Opción A","option_b":"Opción B","payment_condition":"Condiciones de Pago","quotation":{"date":"Fecha","info":"Datos de la Cotización","number":"Número","type":"Tipo"},"quotation_number":"Cotización No.","services":"Propuesta Económica/Resumen","warranty":"Garantía"}},"states":{"accepted":"Aprobada por el Cliente","active":"Activa","created":"Creada","expired":"Expirada"},"update":{"error":"Ha ocurrido un error al actualizar la cotización"}},"ransack":{"all":"todos","and":"y","any":"cualquier","asc":"ascendente","attribute":"atributo","combinator":"combinador","condition":"condición","desc":"descendente","or":"o","predicate":"predicado","predicates":{"blank":"está en blanco","cont":"contiene","cont_all":"contiene todos","cont_any":"contiene cualquier","does_not_match":"no coincide con","does_not_match_all":"no coincide con todos","does_not_match_any":"no coincide con ninguno","end":"termina en","end_all":"termina en todos","end_any":"termina en cualquier","eq":"es igual a","eq_all":"es igual a todos","eq_any":"es igual a cualquier","false":"es falso","gt":"mayor que","gt_all":"mayor que todos","gt_any":"mayor que cualquier","gteq":"mayor que o igual a","gteq_all":"mayor que o igual a todos","gteq_any":"mayor que o igual a cualquier","in":"en","in_all":"en todos","in_any":"en cualquier","lt":"menor que","lt_all":"menor o igual a","lt_any":"menor que cualquier","lteq":"menor que o igual a","lteq_all":"menor o igual a todos","lteq_any":"menor o igual a cualquier","matches":"coincide con","matches_all":"coincide con todos","matches_any":"coincide con cualquier","not_cont":"no contiene","not_cont_all":"no contiene todos","not_cont_any":"no contiene ninguno","not_end":"no termina en","not_end_all":"no termina en todos","not_end_any":"no termina en cualquier","not_eq":"no es igual a","not_eq_all":"no es igual a todos","not_eq_any":"no es igual a cualquier","not_in":"no en","not_in_all":"no en todos","not_in_any":"no en cualquier","not_null":"no es nulo","not_start":"no comienza con","not_start_all":"no comienza con todos","not_start_any":"no comienza con cualquier","null":"es nulo","present":"está presente","start":"comienza con","start_all":"comienza con todos","start_any":"comienza con cualquier","true":"es verdadero"},"search":"buscar","sort":"ordenar","value":"valor"},"services":{"api_update_batch":{"errors":{"main":"Ha ocurrido un error al intentar actualizar los precios de los servicios especificados","service_does_not_exist":"El servicio con id %{service} no existe"}},"create":{"success":"El servicio fue creado  satisfactoriamente."},"destroy":{"destroy":"El material ha sido eliminada satisfactoriamente."},"edit":{"edit_service":"Editar Servicio"},"index":{"delete_modal":{"body":"Una vez eliminado no podrás recuperarlo y deberás crear uno nuevo. Todas la información asociada a este servicio (productos, cotizaciones, etc.) seguirá existiendo.","no_text":"Cancelar","title":"¿Realmente deseas eliminiar este servicio?","yes_text":"Sí, elimínalo"},"description":"Descripción","name":"Servicio","new":"Nuevo Servicio","no_results_found":"No hay resultados para mostrar.","page_size_placeholder":"Filas por página","price":"Precio","search_name":"Nombre del servicio","search_title":"Filtrar por"},"new":{"new_service":"Nuevo Servicio"},"return":"Regresar","save":"Guardar","search":"Buscar","show":{"back":"Regresar","edit":"Editar"},"title":"Servicios","update":{"update":"El servicio fue actualizado  satisfactoriamente."}},"support":{"array":{"last_word_connector":" y ","two_words_connector":" y ","words_connector":", "}},"time":{"am":"am","formats":{"default":"%A, %-d de %B de %Y %H:%M:%S %z","long":"%-d de %B de %Y %H:%M","short":"%-d de %b %H:%M"},"pm":"pm"},"title":"Cotizador de Proyectos de Infraestructura","users":{"avatar":"Foto","email":"Correo Electrónico","name":"Nombre","new_password":"Nueva Contraseña","password":"Contraseña","password_confirmation":"Confirmar Contraseña","phone":"Teléfono","registrations":{"account":{"account":"Mi Cuenta","forgot_password":"¿Olvidaste tu contraseña?","login":"Iniciar Sesión","logout":"Cerrar Sesión","omniauth":"Inciar sesión con %{provider}","register":"Registrate","reset":"Cambiar Contraseña","reset_email_not_received":"¿No recibiste instrucciones de reinicio?","send_reset_email":"Envíar Correo","unlock_email_not_received":"¿No recibiste instrucciones para desbloquear?"},"account_form":{"edit_image":"Subir Imagen","password":"Contraseña","password_confirmation":"Confirmar Contraseña","save":"Actualizar mis datos"},"create":{"success":"El usuario %{username} ha sido creado satisfactoriamente"},"destroy":{"destroy":"El usuario %{username} ha sido eliminado satisfactoriamente"},"edit":{"edit_user":"Editar Usuario"},"edit_form":{"lastname":"Apellido(s)","name":"Nombres(s)","reset":{"body":"¿Estas seguro que deseas reiniciar la contraseña de este usuario? Una nueva contraseña será generada y enviada al correo: %{email}","confirm":"Sí, reiniciala","title":"Reiniciar Contraseña"},"role":"Rol"},"index":{"delete_modal":{"body":"Una vez eliminado no podrás crear un nuevo usuario con este correo. Todas la información asociada a este usuario seguirá existiendo.","no_text":"Cancelar","title":"¿Realmente deseas eliminiar a este usuario?","yes_text":"Sí, elimínalo"},"new":"Nuevo Usuario","page_size_placeholder":"Filas por página","placeholder":{"search":"Correo del Usuario"},"search":"Buscar","search_title":"Filtrar por","title":"Usuarios"},"new":{"new_user":"Nuevo Usuario","role_blank":"Seleccionar Rol"},"new_form":{"lastname":"Apellido(s)","name":"Nombres(s)","role":"Rol"},"reset_password":{"reset_password":"La contraseña del usuario %{username} ha sido reiniciada satisfactoriamente"},"show":{"back":"Regresar","edit":"Editar"},"update":{"update":"El usuario %{username} ha sido actualizada satisfactoriamente"},"update_account":{"update":"Tus datos han sido actualizados satisfactoriamente"}},"reset":{"email_title":"Reiniciar Contraseña","reset_title":"Cambia tu Contraseña","verifications":{"password_length":"(Mínimo %{length} caracteres)"}},"return":"Regresar","role":"Rol","save":"Guardar","user_type":"Tipo de Usuario"},"views":{"pagination":{"first":"\u0026laquo; Primera","last":"Última \u0026raquo;","next":"Siguiente \u0026rsaquo;","previous":"\u0026lsaquo; Anterior","truncate":"\u0026hellip;"}}});
