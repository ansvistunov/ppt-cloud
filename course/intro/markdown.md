# Введение в облачные вычисления
---
### Что такое JavaScript?
 - Прежде всего – язык программирования​
 - Которым не владеет какая-либо компания или организация (торговый знак принадлежит Oracle)​
 - Стандартизован (стандарт ECMA-262), также утвержден ISO как ISO-16262​
 - Обычно используется как встраиваемый язык​
 - Модель выполнения как правило- интерпретация ​
 - Появился в 1995, автор Брендан Эйх (Netscape)​
 - В настоящий момент – самый популярный язык, используемый для ВЕБ-разработки ​
---
### Стек технологий
![Web stack](../img/webstack.png)
---
<!-- .slide: data-background-iframe="https://octoverse.github.com/2022/top-programming-languages#Line%20737" data-background-interactive -->
---
### Объекты в JavaScript. Массивы
* Объект это ассоциативный массив: структура, пригодная для хранения любых данных в виде структуры «ключ-значение» (хеш-таблица). ​
* Объекты предоставляют языковые возможности для объектно-ориентированного программирования. ​
---
### Объекты в JavaScript. Массивы
* Создание (пустой объект): 
```js 
let o = new Object();​
let o1 = {}; // пустые фигурные скобки​​
```
* Создание (объект с содержимым)​: 
```js 
let user = { name: “Маша", age: 25};​
```
* Операции 

```js 
//Создание свойства и присвоение ему значения ​
o.key1 = value; o.name=‘Ivan’;​

//Доступ к значению свойства​
alert(o.name); //или 
alert(o[‘name’]);​

//Удаление свойства​
delete o.name​

//Проверка наличия свойства в объекте​
If (“name” in o) {…} или if (o.name===undefined)​​
```
---
### Объекты в JavaScript. Массивы
* Перебор всех свойств объекта. Цикл for ..in​​
```js 
for (let key in obj) {​
    console.log(obj[key]);​
}​
```
* Ссылки на объекты​: при присваивании в JavaScript всегда осуществляется создание ссылки на объект​
```js 
let user = { name: 'Вася' };​
let admin = user;​
admin.name = 'Петя'; // поменяли данные через admin​
alert(user.name); // 'Петя', изменения видны в user​
```
---
### Глобальный объект
* Глобальными называют переменные и функции, которые не находятся внутри какой-то функции.​
* В JavaScript все глобальные переменные и функции являются свойствами специального объекта, который называется «глобальный объект» (global object).​
* В браузере этот объект доступен под именем window. Объект window одновременно является глобальным объектом и содержит ряд свойств и методов для работы с окном браузера​
* Присваивая или читая глобальную переменную, мы, фактически, работаем со свойствами window​
```js 
var a = 5;  alert( window.a ); // 5​​
//или так
window.a = 5; alert( a ); // 5​
```
---
### Объекты «в стиле ООП»​
* При объявлении объекта можно указать свойство-функцию, например:

```js 
var user = {​
    name: 'Вася',​
    // метод​
    sayHi: function() {​
        alert( 'Привет,'+ name );​
    }​
};​

// Вызов​
user.sayHi();​
```
---
### Объекты «в стиле ООП»​
* Свойства-функции называют «методами» объектов. Их можно добавлять и удалять в любой момент, в том числе и явным присваиванием:​

```js 
var user = {​
    name: 'Вася'​
};​

user.sayHi = function() { ​
    alert('Привет, ' + name);​
};​

// Вызов метода:​
user.sayHi();​
```
---
### Доступ к объекту через this
* Для доступа к текущему объекту из метода используется ключевое слово this.​

```js 
var user = {​
    name: 'Вася'​
};​

user.sayHi = function() { ​
    alert('Привет, '+ this.name);​
};​

// Вызов метода:​
user.sayHi();​
```
---
### Подробнее про this​
* Любая функция может иметь в себе this. Совершенно неважно, объявлена ли она в объекте или отдельно от него.​
* Значение this называется контекстом вызова и будет определено в момент вызова функции.​

```js 
let user = { firstName: "Вася" };​
let admin = { firstName: "Админ" };​
function func() {alert( this.firstName );}​
user.f = func;  
admin.g = func;​

user.f(); // Вася​
admin.g(); // Админ​
admin['g'](); // Админ​
```
---
### Подробнее про this​
* Если функция использует this – это подразумевает работу с объектом. Прямой вызов func() так же возможен.​
* При этом this получает значение глобального объекта (window) в старом стандарте или undefined в новом:​

```js 
function func() {​
    alert( this ); ​
    // выведет [object global] в старом стандарте или undefined в новом​
}​

func();​​
```
---
### Преобразование объектов​
* Бывают операции, при которых объект должен быть преобразован в примитив, например:​
    * Строковое преобразование – если объект выводится через alert(obj).​
    * Численное преобразование – при арифметических операциях, сравнении с примитивом.​
    * Логическое преобразование – при if(obj) и других логических операциях.​
---
### Логическое преобразование​
* Любой объект в логическом контексте – true, даже если это пустой массив [] или объект {}.​

```js 
if ({} && []) {​
    alert( "Все объекты - true!" ); // alert сработает​
}​
```
---
### Преобразование в строку
* Преобразование по умолчанию возвращает строку [object Object]​
* Поведение по умолчанию можно переопределить​

```js 
var user = {​
    firstName: 'Василий',​
    toString: function() {​
        return 'Пользователь ' + this.firstName;​
    }​
};​

alert( user );  // Пользователь Василий​
```
---
### Преобразование в число​
* Для численного преобразования объекта используется метод valueOf, а если его нет – то toString:​

```js 
let room = {​
    number: 777,​
    valueOf: function() { return this.number; },​
    toString: function() { return this.number; }​
};​

alert( +room );  // 777, вызвался valueOf​
delete room.valueOf; // valueOf удалён​
alert( +room );  // 777, вызвался toString​
```
---
### Стадии преобразования​
* Если объект преобразован в примитив при помощи toString или valueOf, то  на этом преобразования не обязательно заканчиваются. Вполне возможно, что в процессе вычислений этот примитив будет преобразован во что-то другое.​

```js 
let a = {​
    valueOf: function() {return "1";}​
};​

let b = { 
    valueOf: function() {return "2";}​
};​

alert( a + b ); // "12"​
alert( a - b ); // "1" - "2" = -1​
```
---
### Объекты и оператор new
* Использование функции-конструктора:

```js 
function Animal(name) {​
    this.name = name;​
    this.canWalk = true;​
}​

var animal = new Animal("кот");​
```
* Технически, функцией-конструктором может быть любая функция!​
* **Принято** функции-конструкторы называть с большой буквы.​
---
### Возврат из функции-конструктора​
* Как правило, конструкторы ничего не возвращают. Их задача – записать всё, что нужно, в this, который автоматически станет результатом.​
* Но если явный вызов return всё же есть, то применяется простое правило:​
    * При вызове return с объектом, будет возвращён он, а не this.​
    * При вызове return с примитивным значением, оно будет отброшено.​
---
### Создание методов в конструкторе
```js 
function User(name) {​
    this.name = name;​
    this.sayHi = function() {​
        alert( "Моё имя: " + this.name );​
    };​
}​

let ivan = new User("Иван");​
ivan.sayHi(); // Моё имя: Иван​
```
---
### Локальные методы и переменные

```js 
function User(firstName, lastName) {​
  // вспомогательная переменная​
    let phrase = "Привет";​
  //  вспомогательная вложенная функция​
    function getFullName() {​
        return firstName + " " + lastName;​
    }​

    this.sayHi = function() {​
        alert( phrase + ", " + getFullName() ); // использование​
    };​
}​

let vasya = new User("Вася", "Петров");​

vasya.sayHi(); // Привет, Вася Петров​
```
---
### Дескрипторы, геттеры и сеттеры свойств​​
* Основной метод для управления свойствами Object.defineProperty. Он позволяет объявить свойство объекта и, тонко настроить его особые аспекты​
* Синтаксис: Object.defineProperty(obj, prop, descriptor)​
* Аргументы:​
    * obj  - объект, в котором объявляется свойство.​
    * Prop- имя свойства, которое нужно объявить или модифицировать.​
    * descriptor -дескриптор – объект, который описывает поведение свойства.​
---
### Свойства дескриптора​
* В дескрипторе могут быть следующие поля​
    * value – значение свойства, по умолчанию undefined​
    * writable – значение свойства можно менять, если true. По умолчанию false.​
    * configurable – если true, то свойство можно удалять, а также менять его в дальнейшем при помощи новых вызовов defineProperty. По умолчанию false.​
    * enumerable – если true, то свойство просматривается в цикле for..in и методе Object.keys(). По умолчанию false.​
    * get – функция, которая возвращает значение свойства. По умолчанию undefined.​
    * set – функция, которая записывает значение свойства. По умолчанию undefined.​​
---
### Примеры
* Обычное свойство:​

```js 
let user = {};​

// 1. простое присваивание​
user.name = "Вася";​

// 2. указание значения через дескриптор​
Object.defineProperty(user, "name", { value: "Вася", 
                                      configurable: true, 
                                      writable: true, 
                                      enumerable: true 
                                      }
                    );​
```
---
### Примеры
* Свойство-константа:​

```js 
"use strict";​

let user = {};​
Object.defineProperty(user, "name", {value: "Вася",​
                                    writable: false, // запретить присвоение                   
                                    configurable: false // запретить удаление​
                                    }
                    );​

// Теперь попытаемся изменить это свойство.​
// в strict mode присвоение "user.name=" вызовет ошибку​
user.name = "Петя";​ //Ошибка
```
---
### Примеры
* Свойство, скрытое для for…in:​​

```js 
let user = {​
    name: "Вася",​
    toString: function() { return this.name; }​
};​

// помечаем toString как не подлежащий перебору в for..in​
Object.defineProperty(user, "toString", ​{enumerable: false});​

for(let key in user) alert(key);  // name​
```
---
### Примеры
* Свойство-функция:​

```js 
let user = {​
    firstName: "Вася",  
    surname: "Петров"​
}​

Object.defineProperty(user, "fullName", 
    {​
        get: function() {return this.firstName + ' ' + this.surname;​ } ​
    }
);​

alert(user.fullName); // Вася Петров​
```
---
### Примеры
* get и set можно создать при объявлении объекта:​

```js 
let user = { firstName: "Вася",surname: "Петров",​
    get fullName() {​
        return this.firstName + ' ' + this.surname;​
    },​
    set fullName(value) { 
        var split = value.split(' ');​
        this.firstName = split[0]; 
        this.surname = split[1]; }​
};​

alert( user.fullName ); // Вася Петров (из геттера)​
user.fullName = "Петя Иванов";​
alert( user.firstName ); // Петя  (поставил сеттер)​
alert( user.surname ); // Иванов (поставил сеттер)​
```
---
### Другие методы работы со свойствами​
* Object.defineProperties(obj, descriptors) - позволяет объявить несколько свойств сразу​
* Object.keys(obj) - возвращает массив – список свойств объекта (только enumerable-свойства) ​
* Object.getOwnPropertyNames(obj) -  возвращает массив – список свойств объекта (все свойства) ​
* Object.getOwnPropertyDescriptor(obj, prop) - возвращает дескриптор для свойства obj[prop].​
* И др..​

---
### Статические свойства и методы​
* Свойства и методы, «записанные» в саму функцию-конструктор называются статическими​

```js 
function Article() {​
    Article.count++;​
}​

Article.count = 0; // статическое свойство-переменная​
Article.DEFAULT_FORMAT = "html"; // статическое свойство-константа​
```
---
### Статические свойства и методы​
* Свойства и методы, «записанные» в саму функцию-конструктор называются статическими​:

```js   
function Article() { 
    Article.count++;
}
Article.count = 0;​
Article.showCount = function() {​
    alert( this.count );​
}​

// использование​
new Article();​
new Article();​
Article.showCount(); // (2)​​
```
---
### Метод call​
* Синтаксис метода call:​
```js 
func.call(context, arg1, arg2, ...)​
```
* При этом вызывается функция func, первый аргумент call становится её this, а остальные передаются в func согласно списку аргументов (arg1, arg2,).​
* Вызов func.call(context, a, b...) – то же, что обычный вызов func(a, b...), но с явно указанным this(=context)

---
### Метод call​

```js 
let user = {​
  firstName: "Василий",​
  surname: "Петров",​
  patronym: "Иванович"​
};​

function showFullName(firstPart, lastPart) {​
  alert( this[firstPart] + " " + this[lastPart] );​
}​

showFullName.call(user, 'firstName', 'surname’) ​
// "Василий Петров"​
showFullName.call(user, 'firstName', 'patronym’) ​
// "Василий Иванович"​
```
---
### Метод apply
* Вызов функции при помощи func.apply работает аналогично func.call, но принимает массив аргументов вместо списка.​
* Используется, когда спиcок параметров нужно формировать динамически​
```js 
func.call(context, arg1, arg2);​
// идентичен вызову​
func.apply(context, [arg1, arg2]);​
```
---
### Объекты и их прототипы
* Объекты в JavaScript можно организовать в цепочки так, чтобы свойство, не найденное в одном объекте, автоматически искалось бы в другом.​
* Если один объект имеет специальную ссылку \__proto__ на другой объект, то при чтении свойства из него, если свойство отсутствует в самом объекте, оно ищется в объекте \__proto__
```js 
let animal = {eats: true};​
let rabbit = {jumps: true};​
rabbit.__proto__ = animal;​
alert( rabbit.jumps ); // true​
alert( rabbit.eats ); // true​
```
---
### Объекты и их прототипы
* Объект, на который указывает ссылка \__proto__, называется «прототипом». ​
* Также говорят, что объект rabbit «прототипно наследует» от animal.​
* Прототип используется исключительно при чтении. Запись значения – работает напрямую с объектом.
```js 
let animal = {eats: true};​
let rabbit = {jumps: true};​
rabbit.__proto__ = animal;​
rabbit.eats = false;​
alert( rabbit.eats ); //false​
```
---
### Объекты и их прототипы
* Обычный цикл for..in не делает различия между свойствами объекта и его прототипа.​
```js 
let animal = {eats: true};​
let rabbit = {jumps: true,__proto__: animal};​
for (let key in rabbit) {​
  alert( key + " = " + rabbit[key] ); ​
// выводит и "eats" и "jumps"​
}​
```
* Вызов obj.hasOwnProperty(prop) возвращает true, если свойство prop принадлежит самому объекту obj, иначе false.​
---
### Объекты и их прототипы
* Установка прототипа при использовании функции-конструктора
```js 
let animal = {eats: true};​
function Rabbit(name) {this.name = name;}​
Rabbit.prototype = animal;​
let rabbit = new Rabbit("Кролик"); ​
//  rabbit.__proto__ == animal​
alert( rabbit.eats ); // true​​
```
---
### Объекты и их прототипы
* По умолчанию (если оно не изменялось), свойство prototype содержит объект вида 

{constructor: <функция-конструктор данного объекта>}​

Т.е. допустим код вида:​
```js 
function Rabbit(name) {​
  this.name = name;​
  alert( name );​
}​
let rabbit = new Rabbit("Братец Кролик");​
let rabbit2 = new rabbit.constructor("Крольчиха");​
```
---
### Объекты и их прототипы
* Все объекты в JavaScript «наследуют» от Object.prototype​
```js 
let obj = {};​
// метод берётся из прототипа?​
alert( obj.toString == Object.prototype.toString ); // true, да​
// проверим, правда ли что __proto__ это Object.prototype?​
alert( obj.__proto__ == Object.prototype ); // true​
// А есть ли __proto__ у Object.prototype?​
alert( obj.__proto__.__proto__ ); // null, нет​
```
---
### Объекты и их прототипы
* Встроенные прототипы можно изменять
```js 
String.prototype.repeat = function(times) {​
    return new Array(times + 1).join(this);​
};​
alert( "ля".repeat(3) ); // ляляля​
```

* Метод repeat теперь доступен для ВСЕХ строк
---
### Наследование методов​
```js 
function Animal(name) {
    this.name = name;
    this.speed = 0;
}​
// 1.1. Методы -- в прототип​
Animal.prototype.stop = function() {
    this.speed = 0;​
    alert( this.name + ' стоит' );
}​
Animal.prototype.run = function(speed) { 
    this.speed += speed;​
    alert( this.name + ' бежит, скорость ' + this.speed );
};​
function Rabbit(name) {
    this.name = name;
    this.speed = 0;
}​
// 2.1. Наследование​
Rabbit.prototype = Object.create(Animal.prototype);​
Rabbit.prototype.constructor = Rabbit;​
// 2.2. Методы Rabbit​
Rabbit.prototype.jump = function() {  
    this.speed++;​
    alert( this.name + ' прыгает, скорость ' + this.speed );
}​
```
---
### Методы родителя
* Переопределение метода родителя​
```js 
Rabbit.prototype.run = function(speed) {​
    this.speed++;   
    this.jump();​
};​​
```
* Вызов метода родителя​
```js 
Rabbit.prototype.run = function() {​
   // вызвать метод родителя, передав ему аргументы​
   Animal.prototype.run.apply(this, arguments);​
   this.jump(); 
}
```
---
### Ключевое слово "class"​
```js 
class Animal { // конструктор 
    constructor(name) { 
        this.name = name; 
        this.speed = 0; 
    } 
//методы класса 
    stop() { 
        this.speed = 0; 
        console.log(this.name + " state with speed " + this.speed); 
    } 
    run(speed) { 
        this.speed += speed; 
        console.log(this.name + ' run with speed:' + this.speed); 
    }
} 
```
---
### Ключевое слово "class"​
```js 
class Rabbit extends Animal {
    jump() {
        this.speed++;
        console.log(this.name + ' jump with speed ' + this.speed);
    }
}

let animal = new Animal("Животное");
let rabbit = new Rabbit("Кролик");
rabbit.stop(); //Кролик stop with speed 0
rabbit.run(10); //Кролик run with speed:10
rabbit.jump(); //Кроликjump with speed 11
```
---
### Как происходит выполнение программы?​
---
### Порядок инициализации
* На первой фазе происходит инициализация, подготовка к запуску.  Во время инициализации скрипт сканируется на предмет объявления функций вида Function Declaration, а затем – на предмет объявления переменных var. Каждое такое объявление добавляется в window.  Функции, объявленные как Function Declaration, создаются сразу работающими, а переменные – равными undefined.​
* На второй фазе происходит выполнение. Присваивание (=) значений переменных происходит, когда поток выполнения доходит до соответствующей строчки кода, до этого они undefined.​
---
### Порядок инициализации
```js 
alert("a" in window); // true,  т.к. есть свойство window.a​
alert(a); // равно undefined,  присваивание будет выполнено далее​
alert(f); // function ...,  готовая к выполнению функция​
alert(g); // undefined, т.к. это переменная, а не Function Declaration​

var a = 5;​
function f() { /*...*/ }​
var g = function() { /*...*/ };​
```
---
### Замыкания. Лексическое окружение​
* Все переменные внутри функции – это свойства специального внутреннего объекта LexicalEnvironment, который создаётся при её запуске. При запуске функция создает объект LexicalEnvironment, записывает туда аргументы, функции и переменные. Процесс инициализации выполняется в том же порядке, что и для глобального объекта, который, вообще говоря, является частным случаем лексического окружения.​
* В отличие от window, объект LexicalEnvironment является внутренним, он скрыт от прямого доступа.​
---
### Замыкания. Лексическое окружение​
* Из функции мы можем обратиться не только к локальной переменной, но и к внешней. Интерпретатор, при доступе к переменной, сначала пытается найти переменную в текущем LexicalEnvironment, а затем, если её нет – ищет во внешнем объекте переменных. В случае браузера им является window.​
---
### Замыкания. Лексическое окружение​
* Каждая функция при создании получает ссылку \[[Scope]] на объект с переменными, в контексте которого была создана.​
* При **запуске** функции **создаётся новый объект** с переменными LexicalEnvironment. Он получает ссылку на внешний объект переменных из \[[Scope]].​
* При поиске переменных он осуществляется сначала в текущем объекте переменных, а потом – по этой ссылке.​
---
### Замыкания. Лексическое окружение​
```js 
function makeCounter() {​
    let currentCount = 1;​
    return function() {return currentCount++;};​
}​

let counter = makeCounter();​
// каждый вызов увеличивает счётчик​
alert( counter() ); // 1​
alert( counter() ); // 2​
alert( counter() ); // 3​

// создать другой счётчик​
let counter2 = makeCounter();​
alert( counter2() ); // 1​
```
---
### Свойства функции
```js 
function makeCounter() {​
    function counter() {​
        return counter.currentCount++;​
    };​
    counter.currentCount = 1;​
    return counter;​
}​

let counter = makeCounter();​
alert( counter() ); // 1​
alert( counter() ); // 2​

counter.currentCount = 5;​
alert( counter() ); // 5​
```
Свойства функции доступны извне и могут быть изменены​
---
### Особенности при использовании Function​
* При создании функции с использованием new Function, её свойство \[[Scope]] ссылается не на текущий LexicalEnvironment, а на window.​

```js 
let a = 1;​
function getFunc() {​
    let a = 2;​
    let func = new Function('', 'alert(a)');​
    return func;​
}​

getFunc()(); // 1, из window !!!​
```
---
### Функция как объект​
```js 
function makeCounter() {​
    let currentCount = 1;​
    function counter() {return currentCount++;}​
    counter.set = function(value){currentCount =value;};​
    counter.reset = function() { currentCount = 1; };​
    return counter;​
}​

let counter = makeCounter();​
alert( counter() ); // 1​
alert( counter() ); // 2​

counter.set(5);​
alert( counter() ); // 5​
```
---
### Использование «Модулей»
* Скобки здесь важны. Из за них выражение превращается в Function Expression.​ В результате в глобальный объект переменные функции не попадут​

```js 
(function() {​
  // глобальная переменная нашего скрипта​
    let message = "Привет";​
  // функция для вывода этой переменной​
    function showMessage() {​
        alert( message );​
    } ​
  // выводим сообщение​
    showMessage();​

})();​
```
---
### Экспорт объектов из модулей​
```js 
(function() {​

  // main - основная функция для библиотеки​
    function main(value) {​
    // ...​
    }​

  // "экспортировать" main из модуля​
    window.m = main; ​

}());​
```
---
### Приложения
---
### CANVAS – элемент HTML 5​
```html 
<!doctype html> ​
<html> 
    <head> ​
        <title>canvasExample</title> 
        <meta charset='utf-8' /> ​
    </head> 
    <body> ​
        <canvas height='320' width='480' id="example"> 
            Обновите браузер
        </canvas>​
        <script> ​
            let example = document.getElementById("example")​
            let ctx = example.getContext('2d'); ​
            ctx.fillRect(0, 0, example.width, example.height); ​
        </script> ​
    </body> 
</html>​
```
---
### CANVAS – элемент HTML 5​
* Прямоугольники​
    * strokeRect(x, y, ширина, высота) // Рисует прямоугольник​
    * fillRect(x, y, ширина, высота)   // Рисует закрашенный прямоугольник​
    * clearRect(x, y, ширина, высота)  // Очищает область на холсте размером с прямоугольник заданного размера​
* Линии и дуги​
    * fill() заливает фигуру сплошным цветом​
    * moveTo(x, y) // перемещает "курсор" в позицию x, y​
    * lineTo(x, y) // ведёт линию из текущей позиции в указанную, и делает в последствии указанную текущей ​
---
### CANVAS – элемент HTML 5​
* Линии и дуги​
    * arc(x, y, radius, startAngle, endAngle, anticlockwise) // рисование дуги, где x и y центр окружности, далее начальный и конечный угол, последний параметр указывает направление​
* Кривые Бернштейна-Безье​
    * quadraticCurveTo(Px, Py, x, y) для построения кубической кривой​
    * bezierCurveTo(P1x, P1y, P2x, P2y, x, y) для построения квадратичной кривой Бизье​
---
### JSON
* JSON (англ. JavaScript Object Notation) — текстовый формат обмена данными, основанный на JavaScript. ​
* Данные в формате JSON (RFC 4627) представляют собой:​
    * JavaScript-объекты { ... } или​
    * Массивы [ ... ] или​
    * Значения одного из типов:​
        * строки в двойных кавычках,​
        * число,​
        * логическое значение true/false,​
        * null.​
* Основные методы для работы с JSON в JavaScript – это:​
    * JSON.parse – создает объекты из строки​
    * JSON.stringify – превращает объект в строку в формате JSON​
---
### JSON (пример)​
```json 
{​
    "name": "Вася",​
    "age": 25,​
    "roles": {​
        "isAdmin": false,​
        "isEditor": true​
    }​,
    "connections":["Oracle", "MSSQL","MySQL"]
}​
```
