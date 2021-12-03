//<?php
/**
 * isMobile
 * 
 * mobiledetect.net
 *
 * @category 	snippet
 * @version 	1
 * @license 	http://www.gnu.org/copyleft/gpl.html GNU Public License (GPL)
 * @internal	@properties 
 * @internal	@modx_category add
 * @internal    @installset base, sample
 */

/*
http://mobiledetect.net - файлик Mobile_Detect.php брать по ссылке 
[!isMobile? 
	&desctop=`<a href="[~[*id*]~]?isMobile=mobile">Мобильная версия</a>`
	&mobile=`<a href="[~[*id*]~]?isMobile=desctop">Полная версия</a>`
!]
[!isMobile? 
    &desctop=`<meta name="viewport" content="width=960">`
	&tablet=`<meta name="viewport" content="width=device-width">`
	&mobile=`<meta name="viewport" content="width=480">`
!]
*/	
//Подключаем библиотеку для детекта устройств	
require_once MODX_BASE_PATH.'assets/snippets/ismobile/Mobile_Detect.php';
$detect = new Mobile_Detect;

//определим старье:
if($detect->isAndroidOS() && $detect->isSafari() && (intval($detect->version('Android')) < 5))
	return $desctop;

//Задаем нужные нам значения для вывода
$tablet = isset($tablet) ? $tablet : '';	
$mobile = isset($mobile) ? $mobile : '';
$desctop = isset($desctop) ? $desctop : '';

//Используем отдельный шаблон для Tablet или нет
$useTablet = isset($useTablet) ? $useTablet : 0;
if ($useTablet == 0) {$tablet = $mobile;}

//Передача переменно isMobile из GET в SESSION для принудительного переключения версий 
if(array_key_exists('isMobile', $_GET))
{
	if (in_array($_GET['isMobile'], array("tablet", "mobile", "desctop")))
	{
		$_SESSION['isMobile'] = $_GET['isMobile'];
	}
}

//Проверка на принудительный вывод нужной версии через параметр в сессии 'isMobile'     
if(array_key_exists('isMobile', $_SESSION))
{
	if($_SESSION['isMobile'] == 'tablet')  return $tablet;
	if($_SESSION['isMobile'] == 'mobile')  return $mobile;
	if($_SESSION['isMobile'] == 'desctop') return $desctop;
}

//Вывод в зависимости от типа устройства
if( $detect->isTablet() ) return $tablet;
if( $detect->isMobile() ) return $mobile;
return $desctop;
