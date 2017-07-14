//
//  ErrorLibrary.swift
//  Izumi
//
//  Created by Ilya Kosolapov on 25.03.16.
//  Copyright © 2016 Ilya Kosolapov. All rights reserved.
//

import Foundation

class ErrorLibrary {
    fileprivate var errArr =
        [
            "err_no_login":["title":"Ошибка","descr":"Не введен логин!"],
            "err_no_pass":["title":"Ошибка","descr":"Не введен пароль!"],
            "err_pass":["title":"Ошибка","descr":"Введен неправильный пароль!"],
            "err_no_user":["title":"Ошибка","descr":"Пользователь не зарегистрирован!"],
            "err_no_cam":["title":"Ошибка","descr":"Камера не обнаружена!"],
            "err_save":["title":"Ошибка","descr":"Ошибка сохранения фотографии!"],
            "err_no_lib":["title":"Ошибка!","descr":"Галерея не обнаружена!"],
            "The request timed out.":["title":"Ошибка сети!","descr":"Превышен лимит ожидания!"],
            "usr_err":["title":"Ошибка!","descr":"Такой пользователь уже существует!"],
            "err_pic":["title":"Ошибка!","descr":"Картинка с таким именем уже существует!"],
            "err_no_pic":["title":"Ошибка!","descr":"Не выбрано изображение!"],
            "demo":["title":"Внимание!","descr":"Магазин работает в тестовом режиме!"],
            "err_pick":["title":"Ошибка!","descr":"Неизвестный источник данных!"],
            "no_avatar":["title":"Внимание!","descr":"Не выбрано изображение профиля!"],
            "no_diploma":["title":"Внимание!","descr":"Нет фотографии диплома!"]
    ];
    
    func returnErrTitle(_ errName : String) -> String {
        return errArr[errName]!["title"]!;
    }
    
    func returnErrDescr(_ errName : String) -> String {
        return errArr[errName]!["descr"]!;
    }
}

class DescriptionLibrary {
    fileprivate var descrArray =
        [
            "triangleHelp":["title":"Описание","descr":"Test1"],
            "revertTriangleHelp":["title":"Описание","descr":"Test2"],
            "hourglassHelp":["title":"Описание","descr":"Test3"],
    ]
    
    func returnDescription(_ figureType: String) -> [String:String] {
        return descrArray[figureType]!
    }
}
