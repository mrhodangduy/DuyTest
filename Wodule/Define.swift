//
//  Define.swift
//  Wodule
//
//  Created by QTS Coder on 10/2/17.
//  Copyright © 2017 QTS. All rights reserved.
//

import Foundation
import UIKit

class APIURL{
    
    static let baseURL = "http://wodule.io/api"
    static let registerURL = "http://wodule.io/api/user_register"
    static var loginURL = "http://wodule.io/api/user_login"
    static let getProfileURL = "http://wodule.io/api/profile"
    static let updateProfileURL = "http://wodule.io/api/profile/update"
    static let categoriesURL = "http://wodule.io/api/category"
    static let allrecordURL = "http://wodule.io/api/records"
    static let getCodeInfoURL = "http://wodule.io/api/code"
    static let updateSocialInfoURL = "http://wodule.io/api/socialite"
    static let getAllrecordURL = "http://wodule.io/api/records?page="

    
}

enum UserType: String    
{
    case examinee = "examinee"
    case assessor = "examiner"
}

let timeCoutdown: TimeInterval = 5
let timeInitial = 4

let SOCIALKEY = "socialKey"
let GOOGLELOGIN = "u03"
let FACEBOOKLOGIN = "u01"
let INSTAGRAMLOGIN = "u02"
let NORMALLOGIN = "normal"

let fontSizeDefaultTV: CGFloat = 17.0
let COMMENTVIEW_HEIGHT : CGFloat = 36/100

let ASSESSOR_STORYBOARD = "Assessor"
let EXAMINEE_STORYBOARD = "Examinee"
let MAIN_STORYBOARD = "Main"
let PROFILE_STORYBOARD = "Profile"

let userDefault = UserDefaults.standard
let TOKEN_STRING = "token"
let USER_STRING = "userinfo"
let FIRSTNAME_STRING = "first_name"
let LASTNAME_STRING = "last_name"
let MIDDLENAME_STRING = "middle_name"
let BIRTHDAY_STRING = "date_of_birth"
let COUNTRYOFBIRTH_STRING = "country_of_birth"
let EMAIL_STRING = "email"
let CITY_STRING = "city"
let COUNTRY_STRING = "country"
let PHONE_STRING = "telephone"
let NATIONALITY_STRING = "nationality"
let STATUS_STRING = "status"
let GENDER_STRING = "gender"
let USERNAME_STRING = "user_name"
let CODE_STRING = "code"
let PASSWORD_STRING = "password"
let NATIVE_STRING = "native"
let SUFFIX_STRING = "suffix"
let ADDRESS1_STRING = "address1"
let ADDRESS2_STRING = "address2"
let ADDRESS3_STRING = "address3"
let ETHNIC_STRING = "ethnicity"
let RELIGION_STRING = "religion"
let LASTNAMEFIRST_STRING = "ln_first"
let TOKENRESET_STRING = "tokenreset"

let SCORE_PART1 = "score_part1"
let SCORE_PART2 = "score_part2"
let SCORE_PART3 = "score_part3"
let SCORE_PART4 = "score_part4"

let NOTIFI_ERROR = "notifcationError"
let NOTIFI_UPDATED = "userUpdated"

let TITLEPHOTO = "Talk about this picture"
let TITLESTRING = "Spoken Interation"

let USERID_STRING = "userID"

let Suffix = ["Mr","Mrs","Miss"]
let Ethnicity = ["Black","White","Hispanic","Asian/Parafic Islander", "Native American","Other"]
let Gender = ["Male","Female"]
let Status = ["Single","Married"]
let Nationality = ["Afghan"
    ,"Albanian"
    ,"Algerian"
    ,"American"
    ,"Andorran"
    ,"Angolan"
    ,"Antiguans"
    ,"Argentinean"
    ,"Armenian"
    ,"Australian"
    ,"Austrian"
    ,"Azerbaijani"
    ,"Bahamian"
    ,"Bahraini"
    ,"Bangladeshi"
    ,"Barbadian"
    ,"Barbudans"
    ,"Batswana"
    ,"Belarusian"
    ,"Belgian"
    ,"Belizean"
    ,"Beninese"
    ,"Bhutanese"
    ,"Bolivian"
    ,"Bosnian"
    ,"Brazilian"
    ,"British"
    ,"Bruneian"
    ,"Bulgarian"
    ,"Burkinabe"
    ,"Burmese"
    ,"Burundian"
    ,"Cambodian"
    ,"Cameroonian"
    ,"Canadian"
    ,"Cape Verdean"
    ,"Central African"
    ,"Chadian"
    ,"Chilean"
    ,"Chinese"
    ,"Colombian"
    ,"Comoran"
    ,"Congolese"
    ,"Costa Rican"
    ,"Croatian"
    ,"Cuban"
    ,"Cypriot"
    ,"Czech"
    ,"Danish"
    ,"Djibouti"
    ,"Dominican"
    ,"Dutch"
    ,"East Timorese"
    ,"Ecuadorean"
    ,"Egyptian"
    ,"Emirian"
    ,"Equatorial Guinean"
    ,"Eritrean"
    ,"Estonian"
    ,"Ethiopian"
    ,"Fijian"
    ,"Filipino"
    ,"Finnish"
    ,"French"
    ,"Gabonese"
    ,"Gambian"
    ,"Georgian"
    ,"German"
    ,"Ghanaian"
    ,"Greek"
    ,"Grenadian"
    ,"Guatemalan"
    ,"Guinea-Bissauan"
    ,"Guinean"
    ,"Guyanese"
    ,"Haitian"
    ,"Herzegovinian"
    ,"Honduran"
    ,"Hungarian"
    ,"I-Kiribati"
    ,"Icelander"
    ,"Indian"
    ,"Indonesian"
    ,"Iranian"
    ,"Iraqi"
    ,"Irish"
    ,"Israeli"
    ,"Italian"
    ,"Ivorian"
    ,"Jamaican"
    ,"Japanese"
    ,"Jordanian"
    ,"Kazakhstani"
    ,"Kenyan"
    ,"Kittian and Nevisian"
    ,"Kuwaiti"
    ,"Kyrgyz"
    ,"Laotian"
    ,"Latvian"
    ,"Lebanese"
    ,"Liberian"
    ,"Libyan"
    ,"Liechtensteiner"
    ,"Lithuanian"
    ,"Luxembourger"
    ,"Macedonian"
    ,"Malagasy"
    ,"Malawian"
    ,"Malaysian"
    ,"Maldivian"
    ,"Malian"
    ,"Maltese"
    ,"Marshallese"
    ,"Mauritanian"
    ,"Mauritian"
    ,"Mexican"
    ,"Micronesian"
    ,"Moldovan"
    ,"Monacan"
    ,"Mongolian"
    ,"Moroccan"
    ,"Mosotho"
    ,"Motswana"
    ,"Mozambican"
    ,"Namibian"
    ,"Nauruan"
    ,"Nepalese"
    ,"New Zealander"
    ,"Ni-Vanuatu"
    ,"Nicaraguan"
    ,"Nigerian"
    ,"Nigerien"
    ,"North Korean"
    ,"Northern Irish"
    ,"Norwegian"
    ,"Omani"
    ,"Pakistani"
    ,"Palauan"
    ,"Panamanian"
    ,"Papua New Guinean"
    ,"Paraguayan"
    ,"Peruvian"
    ,"Polish"
    ,"Portuguese"
    ,"Qatari"
    ,"Romanian"
    ,"Russian"
    ,"Rwandan"
    ,"Saint Lucian"
    ,"Salvadoran"
    ,"Samoan"
    ,"San Marinese"
    ,"Sao Tomean"
    ,"Saudi"
    ,"Scottish"
    ,"Senegalese"
    ,"Serbian"
    ,"Seychellois"
    ,"Sierra Leonean"
    ,"Singaporean"
    ,"Slovakian"
    ,"Slovenian"
    ,"Solomon Islander"
    ,"Somali"
    ,"South African"
    ,"South Korean"
    ,"Spanish"
    ,"Sri Lankan"
    ,"Sudanese"
    ,"Surinamer"
    ,"Swazi"
    ,"Swedish"
    ,"Swiss"
    ,"Syrian"
    ,"Taiwanese"
    ,"Tajik"
    ,"Tanzanian"
    ,"Thai"
    ,"Togolese"
    ,"Tongan"
    ,"Trinidadian or Tobagonian"
    ,"Tunisian"
    ,"Turkish"
    ,"Tuvaluan"
    ,"Ugandan"
    ,"Ukrainian"
    ,"Uruguayan"
    ,"Uzbekistani"
    ,"Venezuelan"
    ,"Vietnamese"
    ,"Welsh"
    ,"Yemenite"
    ,"Zambian"
    ,"Zimbabwean"]


let CountryList = ["Afghanistan",
                   "Albania",
                   "Algeria",
                   "American Samoa",
                   "Andorra",
                   "Angola",
                   "Anguilla",
                   "Antarctica",
                   "Antigua and Barbuda",
                   "Argentina",
                   "Armenia",
                   "Aruba",
                   "Australia",
                   "Austria",
                   "Azerbaijan",
                   "Bahamas",
                   "Bahrain",
                   "Bangladesh",
                   "Barbados",
                   "Belarus",
                   "Belgium",
                   "Belize",
                   "Benin",
                   "Bermuda",
                   "Bhutan",
                   "Bolivia (Plurinational State of)",
                   "Bonaire, Sint Eustatius and Saba",
                   "Bosnia and Herzegovina",
                   "Botswana",
                   "Bouvet Island",
                   "Brazil",
                   "British Indian Ocean Territory",
                   "United States Minor Outlying Islands",
                   "Virgin Islands (British)",
                   "Virgin Islands (U.S.)",
                   "Brunei Darussalam",
                   "Bulgaria",
                   "Burkina Faso",
                   "Burundi",
                   "Cambodia",
                   "Cameroon",
                   "Canada",
                   "Cabo Verde",
                   "Cayman Islands",
                   "Central African Republic",
                   "Chad",
                   "Chile",
                   "China",
                   "Christmas Island",
                   "Cocos (Keeling) Islands",
                   "Colombia",
                   "Comoros",
                   "Congo",
                   "Congo (Democratic Republic of the)",
                   "Cook Islands",
                   "Costa Rica",
                   "Croatia",
                   "Cuba",
                   "Curaçao",
                   "Cyprus",
                   "Czech Republic",
                   "Denmark",
                   "Djibouti",
                   "Dominica",
                   "Dominican Republic",
                   "Ecuador",
                   "Egypt",
                   "El Salvador",
                   "Equatorial Guinea",
                   "Eritrea",
                   "Estonia",
                   "Ethiopia",
                   "Falkland Islands (Malvinas)",
                   "Faroe Islands",
                   "Fiji",
                   "Finland",
                   "France",
                   "French Guiana",
                   "French Polynesia",
                   "French Southern Territories",
                   "Gabon",
                   "Gambia",
                   "Georgia",
                   "Germany",
                   "Ghana",
                   "Gibraltar",
                   "Greece",
                   "Greenland",
                   "Grenada",
                   "Guadeloupe",
                   "Guam",
                   "Guatemala",
                   "Guernsey",
                   "Guinea",
                   "Guinea-Bissau",
                   "Guyana",
                   "Haiti",
                   "Heard Island and McDonald Islands",
                   "Holy See",
                   "Honduras",
                   "Hong Kong",
                   "Hungary",
                   "Iceland",
                   "India",
                   "Indonesia",
                   "Côte d'Ivoire",
                   "Iran (Islamic Republic of)",
                   "Iraq",
                   "Ireland",
                   "Isle of Man",
                   "Israel",
                   "Italy",
                   "Jamaica",
                   "Japan",
                   "Jersey",
                   "Jordan",
                   "Kazakhstan",
                   "Kenya",
                   "Kiribati",
                   "Kuwait",
                   "Kyrgyzstan",
                   "Lao People's Democratic Republic",
                   "Latvia",
                   "Lebanon",
                   "Lesotho",
                   "Liberia",
                   "Libya",
                   "Liechtenstein",
                   "Lithuania",
                   "Luxembourg",
                   "Macao",
                   "Macedonia (the former Yugoslav Republic of)",
                   "Madagascar",
                   "Malawi",
                   "Malaysia",
                   "Maldives",
                   "Mali",
                   "Malta",
                   "Marshall Islands",
                   "Martinique",
                   "Mauritania",
                   "Mauritius",
                   "Mayotte",
                   "Mexico",
                   "Micronesia (Federated States of)",
                   "Moldova (Republic of)",
                   "Monaco",
                   "Mongolia",
                   "Montenegro",
                   "Montserrat",
                   "Morocco",
                   "Mozambique",
                   "Myanmar",
                   "Namibia",
                   "Nauru",
                   "Nepal",
                   "Netherlands",
                   "New Caledonia",
                   "New Zealand",
                   "Nicaragua",
                   "Niger",
                   "Nigeria",
                   "Niue",
                   "Norfolk Island",
                   "Korea (Democratic People's Republic of)",
                   "Northern Mariana Islands",
                   "Norway",
                   "Oman",
                   "Pakistan",
                   "Palau",
                   "Palestine, State of",
                   "Panama",
                   "Papua New Guinea",
                   "Paraguay",
                   "Peru",
                   "Philippines",
                   "Pitcairn",
                   "Poland",
                   "Portugal",
                   "Puerto Rico",
                   "Qatar",
                   "Republic of Kosovo",
                   "Réunion",
                   "Romania",
                   "Russian Federation",
                   "Rwanda",
                   "Saint Barthélemy",
                   "Saint Helena, Ascension and Tristan da Cunha",
                   "Saint Kitts and Nevis",
                   "Saint Lucia",
                   "Saint Martin (French part)",
                   "Saint Pierre and Miquelon",
                   "Saint Vincent and the Grenadines",
                   "Samoa",
                   "San Marino",
                   "Sao Tome and Principe",
                   "Saudi Arabia",
                   "Senegal",
                   "Serbia",
                   "Seychelles",
                   "Sierra Leone",
                   "Singapore",
                   "Sint Maarten (Dutch part)",
                   "Slovakia",
                   "Slovenia",
                   "Solomon Islands",
                   "Somalia",
                   "South Africa",
                   "South Georgia and the South Sandwich Islands",
                   "Korea (Republic of)",
                   "South Sudan",
                   "Spain",
                   "Sri Lanka",
                   "Sudan",
                   "Suriname",
                   "Svalbard and Jan Mayen",
                   "Swaziland",
                   "Sweden",
                   "Switzerland",
                   "Syrian Arab Republic",
                   "Taiwan",
                   "Tajikistan",
                   "Tanzania, United Republic of",
                   "Thailand",
                   "Timor-Leste",
                   "Togo",
                   "Tokelau",
                   "Tonga",
                   "Trinidad and Tobago",
                   "Tunisia",
                   "Turkey",
                   "Turkmenistan",
                   "Turks and Caicos Islands",
                   "Tuvalu",
                   "Uganda",
                   "Ukraine",
                   "United Arab Emirates",
                   "United Kingdom of Great Britain and Northern Ireland",
                   "United States of America",
                   "Uruguay",
                   "Uzbekistan",
                   "Vanuatu",
                   "Venezuela (Bolivarian Republic of)",
                   "Viet Nam",
                   "Wallis and Futuna",
                   "Western Sahara",
                   "Yemen",
                   "Zambia",
                   "Zimbabwe"]


