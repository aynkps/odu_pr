
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ТолькоПросмотр = Истина;
	
	ПустаяСсылкаПредставление = Строка(ТипЗнч(Объект.ЗначениеПустойСсылки));
	
	Если НЕ Пользователи.ЭтоПолноправныйПользователь(, Истина)
	 ИЛИ Справочники.ИдентификаторыОбъектовМетаданных.ЗапрещеноИзменятьПолноеИмя(Объект) Тогда
		
		Элементы.ФормаВключитьВозможностьРедактирования.Видимость = Ложь;
	КонецЕсли;
	
	Если ОбщегоНазначения.ЭтоПодчиненныйУзелРИБ() Тогда
		Элементы.ФормаВключитьВозможностьРедактирования.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВключитьВозможностьРедактирования(Команда)
	
	ТолькоПросмотр = Ложь;
	Элементы.ФормаВключитьВозможностьРедактирования.Доступность = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ПолноеИмяПриИзменении(Элемент)
	
	ПолноеИмя = Объект.ПолноеИмя;
	ОбновитьСвойстваИдентификатора();
	
	Если ПолноеИмя <> Объект.ПолноеИмя Тогда
		Объект.ПолноеИмя = ПолноеИмя;
		ПоказатьПредупреждение(, СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Объект метаданных не найден по полному имени:
			           |%1.'"),
			ПолноеИмя));
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ОбновитьСвойстваИдентификатора()
	
	Справочники.ИдентификаторыОбъектовМетаданных.ОбновитьСвойстваИдентификатора(Объект);
	
КонецПроцедуры

#КонецОбласти
