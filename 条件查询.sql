#进阶二：条件查询
/*
语法：
select 查询列表
from 表
where 筛选条件;

执行顺序
① from子句
② where 子句
③ select 子句

select last_name,first_name from employees where salary > 2000;

特点：
1、按关系表达式筛选
关系运算符 > < >= <= = != <>
	不建议使用!=
	
2、按逻辑运算筛选
逻辑运算符
AND OR NOT
&&  ||  !

3、模糊查询
like
between and
is null

*/

SELECT last_name,first_name FROM employees WHERE salary > 2000;
#一、按关系表达式筛选
#案例1、查询部门编号不是100的员工信息
SELECT 
  * 
FROM
  employees 
WHERE department_id != 100 ;

#案例二、查询工资小于15000的姓名和工资


SELECT 
  CONCAT(last_name, " ", first_name) AS "姓名",
  salary 
FROM
  employees 
WHERE salary < 15000 ;

#二、按逻辑表达式查询
#案例1：查询部门编号不是50 -100 之间的员工姓名、部门编号、邮箱

#方式1
SELECT 
  CONCAT(last_name, " ", first_name) AS "姓名",
  department_id,
  email 
FROM
  employees 
WHERE department_id < 50 
  OR department_id > 100 ;
  
#方式2
SELECT 
  CONCAT(last_name, " ", first_name) AS "姓名",
  department_id,
  email 
FROM
  employees 
WHERE !(department_id > 50 
  AND department_id < 100) ;

#案例2、查询奖金率 > 0.03或者 员工编号在60-100之间的员工信息
SELECT 
  * 
FROM
  employees 
WHERE (
    commission_pct > 0.03 
    AND employee_id > 110
  ) ;

 
#三、模糊查询
/*
一般和通配符搭配使用，对字符数据进行部分匹配查询
常见的通配字符
_ 任意单个字符
% 任意多个字符

也可以使用not like
*/
#案例一、 查询姓名中包含字符a的员工信息
SELECT 
  * 
FROM
  employees 
WHERE last_name LIKE '%a%' ;
#案例二、姓名中最后一个字符为e的员工信息
SELECT 
  * 
FROM
  employees 
WHERE last_name LIKE '%e' ;

#案例三、姓名第一个字符为m的员工信息
SELECT 
  * 
FROM
  employees 
WHERE last_name LIKE 'm%' ;

#案例四、姓名中包含三个字母为x的员工信息
SELECT 
  * 
FROM
  employees 
WHERE last_name LIKE '__x%' ;

#案例四、姓名第二字符为_的员工信息
SELECT 
  * 
FROM
  employees 
WHERE last_name LIKE '_\_%' ;

#或者
SELECT 
  * 
FROM
  employees 
WHERE last_name LIKE '_&_%' ESCAPE '&';

#2、in
/*
功能：查询某字段的值是否属于指定的列表范围内
in(常量值1，常量值2，常量值3，...)
或者 not in(常量值1，常量值2，常量值3，...)
*/
#案例1：查询部门编号是30，50，90的员工信息
SELECT 
  last_name,
  department_id 
FROM
  employees 
WHERE department_id IN (30, 50, 90) ;
# not in
SELECT 
  last_name,
  department_id 
FROM
  employees 
WHERE department_id NOT IN (30, 50, 90) ;


#只是简洁性不一样
SELECT 
  last_name,
  department_id 
FROM
  employees 
WHERE department_id = 30 
  OR department_id = 50 
  OR department_id = 90;
   
#案例二、查询工种编号不是SH_CLERK或者IT_PROG的员工信息
SELECT 
  * 
FROM
  employees 
WHERE job_id IN ("SH_CLERK", "IT_PROG") ;

#3、between and
/*
功能：判断某个字段的值是否介于什么之间
between and / not between and
*/
#案例1、查询部门编号是30-90之间的部门编号
SELECT 
  department_id,
  last_name 
FROM
  employees 
WHERE department_id BETWEEN 30 
  AND 90 ;
#30和90不可以颠倒

#案例2、查询年薪不是100000-200000之间的员工、工资、年薪
SELECT 
  last_name,
  salary,
  salary * 12 * (1 + IFNULL(commission_pct, 0)) AS annual 
FROM
  employees 
WHERE NOT (salary * 12 * (1 + IFNULL(commission_pct, 0)) > 100000 OR salary * 12 * (1 + IFNULL(commission_pct, 0)) < 20000);


#
SELECT 
  last_name,
  salary,
  salary * 12 * (1 + IFNULL(commission_pct, 0)) AS annual 
FROM
  employees 
WHERE salary * 12 * (1 + IFNULL(commission_pct, 0)) NOT BETWEEN 100000 AND 20000;

#4、is null/is not null
#案例1：查询奖金率为空的员工信息
SELECT 
  * 
FROM
  employees 
WHERE commission_pct IS NULL ;

SELECT 
  * 
FROM
  employees 
WHERE commission_pct IS NOT NULL ;


SELECT 
  * 
FROM
  employees 
WHERE salary IS 10000 ;
#<-------------->
#
# = 	只能判断普通内容
# IS	只能用来判断null值
#<=> 	安全等于，既能判断普通内容，也能判断null值
#