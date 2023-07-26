-- see sales data with persons name
select s.SPID,s.amount,p.Salesperson  from 
sales s
join people p
on s.SPID=p.SPID
order by s.SPID;

-- product name and person name  that we are selling in this shipment
select s.SPID,s.amount,p.Salesperson,s.PID,pr.Product from 
sales s
join people p
on s.SPID=p.SPID
join products pr
on pr.PID=s.PID
order by s.SPID;
-- specific amount range and team
select s.SPID,s.amount,p.Salesperson,s.PID,pr.Product,p.Team from 
sales s
join people p
on s.SPID=p.SPID
join products pr
on pr.PID=s.PID
where s.amount<500
and p.team="delish";

-- prople that doesent belong to any team
select s.SPID,s.amount,p.Salesperson,s.PID,pr.Product,p.Team from 
sales s
join people p
on s.SPID=p.SPID
join products pr
on pr.PID=s.PID
where s.amount<500
and p.team="";

-- people  from newzealand or india

select s.SaleDate, s.SPID,s.amount,p.Salesperson,s.PID,pr.Product,p.Team,g.GeoID,g.Geo from 
sales s
join people p
on s.SPID=p.SPID
join products pr
on pr.PID=s.PID
join geo g 
on g.GeoID = s.GeoID
where g.Geo  in ("INDIA","New Zealand")
and p.team=""
and amount<500
order by s.SaleDate;


