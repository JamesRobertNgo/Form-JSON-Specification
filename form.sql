
/*========================================*\
| FORM                                     |
|==========================================|
| PK | FORM_ID                             |
|    | ACTON                               |
|    | METHOD                              |
\*========================================*/

select
	'F'                           as 'COL_01',
	CAST(FORM_ID as VARCHAR2)     as 'COL_02',
	CAST(ACTON as VARCHAR2)       as 'COL_03',
	CAST(METHOD as VARCHAR2)      as 'COL_04',
	null                          as 'COL_05',
	null                          as 'COL_06',
	null                          as 'COL_07',
	null                          as 'COL_08',
	null                          as 'COL_09'
from
	FORM
where
	FORM_ID = ${form_id}

union

/*========================================*\
| FORMATTRIBUTE                            |
|==========================================|
| PK | FORMATTRIBUTE_ID                    |
|    | NAME                                |
|    | VALUE                               |
| FK | FORM_ID                             |
\*========================================*/

select
	'FA'                               as 'COL_01',
	CAST(FORMATTRIBUTE_ID as VARCHAR2) as 'COL_02',
	CAST(NAME as VARCHAR2)             as 'COL_03',
	CAST(VALUE as VARCHAR2)            as 'COL_04',
	null                               as 'COL_05',
	null                               as 'COL_06',
	null                               as 'COL_07',
	null                               as 'COL_08',
	null                               as 'COL_09'
from
	FORMATTRIBUTE
where
	FORM_ID = ${form_id}

union

/*========================================*\
| FORMMODTYPE                              |
|==========================================|
| PK | FORMMODTYPE_CD                      |
|    | MODCODE                             |
\*========================================*/

/*========================================*\
| FORMMOD                                  |
|==========================================|
| PK | FORMMOD_ID                          |
|    | DATA                                |
|    | ORDER                               |
| FK | FORM_ID                             |
| FK | FORMMODTYPE_CD                      |
\*========================================*/

select
	'FM'                                         as 'COL_01',
	CAST(FORMMOD.FORMMOD_ID as VARCHAR2)         as 'COL_02',
	CAST(FORMMOD.DATA as VARCHAR2)               as 'COL_03',
	CAST(FORMMODTYPE.FORMMODTYPE_CD as VARCHAR2) as 'COL_04',
	CAST(FORMMODTYPE.MODCODE as VARCHAR2)        as 'COL_05',
	null                                         as 'COL_06',
	null                                         as 'COL_07',
	null                                         as 'COL_08',
	null                                         as 'COL_09'
from
	FORMMOD,
	FORMMODTYPE
where
	FORMMOD.FORM_ID = ${form_id}
	and FORMMOD.FORMMODTYPE_CD = FORMMODTYPE.FORMMODTYPE_CD
order by
	FORMMOD.ORDER

union

/*========================================*\
| ELEMENTTYPE                              |
|==========================================|
| PK | ELEMENTTYPE_CD                      |
|    | NAME                                |
|    | ISCONTAINER                         |
|    | ELEMENTCODE                         |
|    | ATTRIBUTECODE                       |
\*========================================*/

/*========================================*\
| ELEMENT                                  |
|==========================================|
| PK | ELEMENT_ID                          |
|    | NAME                                |
|    | LABEL                               |
|    | ORDER                               |
| FK | ELEMENTTYPE_CD                      |
| FK | PARENT_ELEMENT_ID                   |
| FK | FORM_ID                             |
\*========================================*/

select
	'E'                                          as 'COL_01',
	CAST(ELEMENT.ELEMENT_ID as VARCHAR2)         as 'COL_02',
	CAST(ELEMENT.NAME as VARCHAR2)               as 'COL_03',
	CAST(ELEMENT.LABEL as VARCHAR2)              as 'COL_04',
	CAST(ELEMENT.PARENT_ELEMENT_ID as VARCHAR2)  as 'COL_05',
	CAST(ELEMENTTYPE.ELEMENTTYPE_CD as VARCHAR2) as 'COL_06',
	CAST(ELEMENTTYPE.NAME as VARCHAR2)           as 'COL_07',
	CAST(ELEMENTTYPE.ELEMENTCODE as VARCHAR2)    as 'COL_08',
	CAST(ELEMENTTYPE.ATTRIBUTECODE as VARCHAR2)  as 'COL_09'
from
	ELEMENT,
	ELEMENTTYPE
where
	ELEMENT.FORM_ID = ${form_id}
	and ELEMENT.ELEMENTTYPE_CD = ELEMENTTYPE.ELEMENTTYPE_CD
order by
	ELEMENT.ORDER

union

/*========================================*\
| ELEMENTATTRIBUTE                         |
|==========================================|
| PK | ELEMENTATTRIBUTE_ID                 |
|    | NAME                                |
|    | VALUE                               |
| FK | ELEMENT_ID                          |
\*========================================*/

select
	'EA'                                                   as 'COL_01',
	CAST(ELEMENTATTRIBUTE.ELEMENTATTRIBUTE_ID as VARCHAR2) as 'COL_02',
	CAST(ELEMENTATTRIBUTE.NAME as VARCHAR2)                as 'COL_03',
	CAST(ELEMENTATTRIBUTE.VALUE as VARCHAR2)               as 'COL_04',
	CAST(ELEMENT.ELEMENT_ID as VARCHAR2)                   as 'COL_05',
	null                                                   as 'COL_06',
	null                                                   as 'COL_07',
	null                                                   as 'COL_08',
	null                                                   as 'COL_09'
from
	ELEMENTATTRIBUTE,
	ELEMENT
where
	and ELEMENTATTRIBUTE.ELEMENT_ID = ELEMENT.ELEMENT_ID
	and ELEMENT.FORM_ID = ${form_id}

union

/*========================================*\
| ELEMENTMODTYPE                           |
|==========================================|
| PK | ELEMENTMODTYPE_CD                   |
|    | NAME                                |
|    | CODE                                |
| FK | ELEMENTTYPE_CD                      |
\*========================================*/

/*========================================*\
| ELEMENTMOD                               |
|==========================================|
| PK | ELEMENTMOD_ID                       |
|    | DATA                                |
|    | ORDER                               |
| FK | ELEMENT_ID                          |
| FK | ELEMENTMODTYPE_CD                   |
\*========================================*/

select
	'EM'                                               as 'COL_01',
	CAST(ELEMENTMOD.ELEMENTMOD_ID as VARCHAR2)         as 'COL_02',
	CAST(ELEMENTMOD.DATA as VARCHAR2)                  as 'COL_03',
	CAST(ELEMENTMODTYPE.ELEMENTMODTYPE_CD as VARCHAR2) as 'COL_04',
	CAST(ELEMENTMODTYPE.NAME as VARCHAR2)              as 'COL_05',
	CAST(ELEMENTMODTYPE.CODE as VARCHAR2)              as 'COL_06',
	CAST(ELEMENT.ELEMENT_ID as VARCHAR2)               as 'COL_07',
	null                                               as 'COL_08',
	null                                               as 'COL_09'
from
	ELEMENTMOD,
	ELEMENTMODTYPE,
	ELEMENT
where
	ELEMENTMOD.ELEMENTMODTYPE_CD = ELEMENTMODTYPE.ELEMENTMODTYPE_CD
	and ELEMENTMOD.ELEMENT_ID = ELEMENT.ELEMENT_ID
	and ELEMENT.FORM_ID = ${form_id}
order by
	ELEMENTMOD.ORDER