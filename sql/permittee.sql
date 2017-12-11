[getList]
SELECT * 
FROM permittee p
inner join permittee_commodity pc on pc.permobjid = p.objid
where permitteename like $P{searchtext}


[getCommoditys]
select *
from permittee_commodity
where permobjid = $P{objid}

[getSGKByCommoditys]
SELECT sgk.* FROM permittee_commodity pc
INNER JOIN sgkind sgk ON sgk.commodityid = pc.commodityid WHERE permobjid = $P{objid} and CURDATE() <= pc.enddate and pc.status <> 'Suspended'

[deleteAllTrainings]
delete from permittee_commodity
where permobjid = $P{objid}

[getLookup]
SELECT r.* FROM commodity r 
WHERE  (r.commodityname LIKE $P{commodityname}  OR r.commoditycode LIKE $P{commoditycode} )
${filter}
ORDER BY r.commodityname

[getPermitteeList]
SELECT * FROM permittee
WHERE permitteename like $P{searchtext}

[getPermittee]
SELECT * FROM permittee WHERE entobjid = $P{objid}

[getReportByPermittee]
SELECT p.permitteename, p.location, c.commodityname, ski.unittype, SUM(poi.sgquantity) AS totquantity, po.receiptdate 
FROM permittee p 
INNER JOIN payorder po ON po.permobjid = p.objid
INNER JOIN payorderitem poi ON po.objid = poi.payorderid
INNER JOIN sgkind_itemaccount ski ON ski.item_objid = poi.item_objid
INNER JOIN sgkind sgk ON sgk.objid = ski.sgobjid
INNER JOIN commodity c ON c.objid = sgk.commodityid
WHERE ski.txntype LIKE '%extraction%' AND po.receiptdate BETWEEN $P{startdate} AND $P{enddate}  
    ${filter} 
GROUP BY p.location, ski.unittype