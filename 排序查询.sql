#进阶3、排序查询
/*
语法：
语法：
select 查询列表
from 表
{where 筛选条件}
order by 排序列表;

执行顺序
① from子句
② where 子句
③ select 子句
④ order by 子句

举例：
select last_name, salary
from employees
where salary > 10000
order by salary;

特点：
1、排序列表可以是单个字段、多个字段、表达式、函数、列数、以及以上的组合
2、升序	asc
   降序	desc
*/
#一、按单个字段排序
#案例1：将员工编号大于120的员工信息，按工资进行升序
SELECT 
  * 
FROM
  employees 
WHERE employee_id > 120 
ORDER BY salary ASC ;

#案例2：将员工编号大于120的员工信息，按工资进行降序

SELECT 
  * 
FROM
  employees 
WHERE employee_id > 120 
ORDER BY salary DESC ;

#二、按表达式排序
#案例1:对有奖金的员工，按年薪降序

SELECT * ,salary*12*(1+IFNULL(`commission_pct`,0)) 
FROM employees
WHERE commission_pct IS NOT NULL
ORDER BY salary*12*(1+IFNULL(`commission_pct`,0)) DESC


SELECT * ,salary*12*(1+IFNULL(`commission_pct`,0))  年薪
FROM employees

ORDER BY 年薪 DESC

#四、按函数结果查询排序

#案例1：按姓名长度进行排序
SELECT LENGTH(last_name),last_name
FROM employees
ORDER BY LENGTH(last_name);


#五、按多个字段排序
#案例1：查询员工的姓名、工资、部门编号，先按工资升序，再按部门编号降序

SELECT 
  last_name,
  salary,
  department_id 
FROM
  employees 
ORDER BY salary ASC,
  department_id DESC ;

#六、按列数排序

SELECT 
  * 
FROM
  employees 
ORDER BY 2 ;

SELECT 
  * 
FROM
  employees 
ORDER BY first_name DESC;
