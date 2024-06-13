///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ОбработкаОбъект 			= ОбъектОбработки();
	Объект.ДоступныеТипыДанных	= ОбработкаОбъект.Метаданные().Реквизиты.ДоступныеТипыДанных.Тип;
	Объект.ПутьКФормам 			= ОбработкаОбъект.Метаданные().ПолноеИмя() + ".Форма";
	
	Элементы.ВидГраницы.СписокВыбора.Добавить("Включая");
	Элементы.ВидГраницы.СписокВыбора.Добавить("Исключая");
	ВидГраницыФормы = Элементы.ВидГраницы.СписокВыбора.Получить(0).Значение;
	
	// Получение списка типов и его фильтрация.
	СписокТипов = ОбъектОбработки().СформироватьСписокТипов();
	ОбъектОбработки().ФильтрацияСпискаТипов(СписокТипов, "Граница");
	
	// Считывание параметров передачи.
	ПараметрыПередачи 	= ПолучитьИзВременногоХранилища(Параметры.АдресХранилища); // см. ОбработкаОбъект.КонсольЗапросов.ПоместитьЗапросыВоВременноеХранилище
	Объект.Запросы.Загрузить(ПараметрыПередачи.Запросы);	
	Объект.Параметры.Загрузить(ПараметрыПередачи.Параметры);
	Объект.ИмяФайла 	= ПараметрыПередачи.ИмяФайла;
	ИдентификаторТекущегоЗапроса 	= ПараметрыПередачи.ИдентификаторТекущегоЗапроса;
	ИдентификаторТекущегоПараметра	= ПараметрыПередачи.ИдентификаторТекущегоПараметра;
	
	ЗаполнитьЗначения();
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия = "ПолучениеМоментаВремени" Тогда 
		ПолучениеМоментаВремени(Параметр);
	КонецЕсли;	
КонецПроцедуры

///////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ

&НаКлиенте
Процедура ТипНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОписаниеОповещения = Новый ОписаниеОповещения("ТипЗавершениеВыбора", ЭтотОбъект);
	СписокТипов.ПоказатьВыборЭлемента(ОписаниеОповещения, НСтр("ru = 'Выбрать тип';
																|en = 'Choose type'"));
	
КонецПроцедуры

&НаКлиенте
Процедура ТипЗавершениеВыбора(ВыбранныйЭлемент, ДополнительныеПараметры) Экспорт
	
	Если ВыбранныйЭлемент <> Неопределено Тогда
		
		ТекущийТип = ВыбранныйЭлемент;
		ИмяТипа    = ТекущийТип.Значение;
		Тип        = ТекущийТип.Представление;
		
		Если ИмяТипа = "МоментВремени" Тогда 
			
			Значение       = Тип;
			ЗначениеВФорме = Тип;
			
		Иначе
			
			Массив = Новый Массив;
			Массив.Добавить(Тип(ИмяТипа));
			Описание = Новый ОписаниеТипов(Массив);
			
			ЗначениеВФорме = Описание.ПривестиЗначение(ИмяТипа);
			Значение       = Описание.ПривестиЗначение(ИмяТипа);
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗначениеВФормеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)

	ПередаваемыеЗапросы = ПередачаЗапросов();
	ПередаваемыеЗапросы.Вставить("Значение",Значение);
	
	Если ИмяТипа = "МоментВремени"  Тогда
		Путь = Объект.ПутьКФормам + "." + "МоментВремени";
		ОткрытьФорму(Путь, ПередаваемыеЗапросы, ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗначениеВФормеПриИзменении(Элемент)
	ИзменениеЗначенияВФорме();
КонецПроцедуры

///////////////////////////////////////////////////////////////////////////
// КОМАНДЫ

&НаКлиенте
Процедура ЗаписатьГраницу(Команда)
	ВыгрузитьГраницуСервер();
КонецПроцедуры

///////////////////////////////////////////////////////////////////////////
// ВСПОМОГАТЕЛЬНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаСервере
Функция ОбъектОбработки()
	Возврат РеквизитФормыВЗначение("Объект");
КонецФункции

// Передача табличной части "Запросы", "Параметры" в виде структуры.
//
&НаСервере
Функция ПередачаЗапросов()
	АдресХранилища		= ОбъектОбработки().ПоместитьЗапросыВоВременноеХранилище(Объект, ИдентификаторТекущегоЗапроса,ИдентификаторТекущегоПараметра);
	ПараметрАдрес		= Новый Структура;
	ПараметрАдрес.Вставить("АдресХранилища", АдресХранилища);
	Возврат ПараметрАдрес;
КонецФункции

&НаСервере
Процедура ПолучениеМоментаВремени(СтруктураПередачи)
	Значение  		= СтруктураПередачи.ВнутрМоментВремени;
	ЗначениеВФорме	= СтруктураПередачи.ПредставлениеМоментаВремени;
КонецПроцедуры	

&НаКлиенте
Процедура ВыгрузитьГраницуСервер()
	
	ПараметрыПередачи = ПоместитьЗапросыВСтруктуру(ИдентификаторТекущегоЗапроса, ИдентификаторТекущегоПараметра);
	Оповестить("ПолучениеГраницы", ПараметрыПередачи);
	Закрыть(ПараметрыПередачи);
	 
	Владелец 					= ВладелецФормы;
	Владелец.Модифицированность = Истина;
	
КонецПроцедуры	

&НаСервере
Функция ВнутрЗначениеОбъектаГраницы()
	ВидГран	= ОбъектОбработки().ОпределениеВидаГраницы(ВидГраницыФормы);
	ГраницаФормы 	= Новый Граница(ЗначениеИзСтрокиВнутр(Значение),ВидГран);
	
	Возврат ЗначениеВСтрокуВнутр(ГраницаФормы);
КонецФункции

&НаСервере
Функция ПоместитьЗапросыВСтруктуру(ИдентификаторЗапроса, ИдентификаторПараметра)
	ПараметрыФормы 	= Объект.Параметры;
	
	ПредставлениеГраницы = СформироватьГраницу();
	
	Для каждого Стр Из ПараметрыФормы Цикл
		Если Стр.Идентификатор = ИдентификаторТекущегоПараметра Тогда
			Стр.Тип		 		= "Граница";
			Стр.Значение 		= ВнутрЗначениеОбъектаГраницы();
			Стр.ТипВФорме		= НСтр("ru = 'Граница';
										|en = 'Border'");
			Стр.ЗначениеВФорме	= ПредставлениеГраницы;
		КонецЕсли;
	КонецЦикла;
	
	ПараметрыПередачи = Новый Структура;
	ПараметрыПередачи.Вставить("АдресХранилища", ОбъектОбработки().ПоместитьЗапросыВоВременноеХранилище(Объект,ИдентификаторЗапроса,ИдентификаторПараметра));
	Возврат ПараметрыПередачи;
КонецФункции	

&НаСервере
Процедура ЗаполнитьЗначения()
	ПараметрыФормы = Объект.Параметры;
	Для каждого ТекущийПараметр Из ПараметрыФормы Цикл
		Если ТекущийПараметр.Идентификатор = ИдентификаторТекущегоПараметра Тогда
			Значение = ТекущийПараметр.Значение;
			Если ПустаяСтрока(Значение) Тогда
				Возврат;
			Иначе
				Прервать;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	Граница = ЗначениеИзСтрокиВнутр(Значение);
	Если ТипЗнч(Граница) <> Тип("Граница") Тогда
		Возврат;
	КонецЕсли;
	
	ЗначениеЗагруженное = Граница.Значение;
	ИмяТипа = ОбъектОбработки().ИмяТипаИзЗначения(ЗначениеЗагруженное);
	Тип = СписокТипов.НайтиПоЗначению(ИмяТипа).Представление;
	Если СтрСравнить(ИмяТипа, "МоментВремени") <> 0 Тогда
		ЗначениеВФорме = ЗначениеЗагруженное;
	Иначе
		ЗначениеВФорме = ОбъектОбработки().ФормированиеПредставленияЗначения(ЗначениеЗагруженное);
	КонецЕсли;
	Значение = ЗначениеВСтрокуВнутр(ЗначениеЗагруженное);
	
	Если Граница.ВидГраницы = ВидГраницы.Включая Тогда
		ВидГраницыФормы = элементы.ВидГраницы.СписокВыбора.Получить(0).Значение;
	Иначе
		ВидГраницыФормы = элементы.ВидГраницы.СписокВыбора.Получить(1).Значение;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Функция СформироватьГраницу()
	ВидГран	= ОбъектОбработки().ОпределениеВидаГраницы(ВидГраницыФормы);
	ГраницаФормы 	= Новый Граница(ЗначениеИзСтрокиВнутр(Значение),ВидГран);
	
	Представление = ОбъектОбработки().ФормированиеПредставленияЗначения(ГраницаФормы);
	
	Возврат Представление;
КонецФункции	

&НаСервере
Процедура ИзменениеЗначенияВФорме()
	Значение = ЗначениеВСтрокуВнутр(ЗначениеВФорме);
КонецПроцедуры	

#КонецОбласти
