
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	Попытка
		
		оду_Клиент.ОбработкаКомандыУОД_ПоОбъекту(ПараметрКоманды, ПараметрыВыполненияКоманды);	
		
	Исключение
		ОписаниеОшибки = ОписаниеОшибки();
		оду_Общий.ОтправитьСообщениеВТелеграмExchange("ОбработкаКоманды оду_ВыполнитьУниверсальныйОбменПоОбъекту", , ОписаниеОшибки);	
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ОписаниеОшибки);
	КонецПопытки;
	
КонецПроцедуры
