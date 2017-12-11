[getListX]
SELECT * 
FROM permittee p
INNER JOIN permittee_commodity1 pc ON pc.permobjid = p.objid
INNER JOIN 
(SELECT pci.objid,SUM(xx.totalqty) AS totalqty FROM permittee_commodity_item pci
INNER JOIN (
SELECT pc.objid,SUM(poi.sgquantity) AS totalqty,sgk.commodityid FROM payorder p
INNER JOIN payorderitem poi ON poi.payorderid = p.objid
INNER JOIN sgkind_itemaccount si ON si.item_objid = poi.item_objid
INNER JOIN sgkind sgk ON sgk.objid = si.sgobjid
INNER JOIN permittee per ON per.objid = p.permobjid
INNER JOIN permittee_commodity1 pc ON pc.permobjid = per.objid 
INNER JOIN permittee_commodity_item pci ON pci.objid = pc.objid AND pci.commodityid = sgk.commodityid
WHERE
si.unit <> 0 AND
p.receiptdate BETWEEN pc.startdate AND pc.enddate
AND CURDATE() <= pc.enddate
AND pc.status <> 'Suspended'
AND p.state <> 'VOIDED'
AND p.permobjid = $P{objid}
GROUP BY sgk.commodityid)xx ON xx.objid = pci.objid AND xx.commodityid = pci.commodityid
GROUP BY pci.objid)bbb ON bbb.objid = pc.objid
WHERE pc.startdate = (SELECT MAX(startdate) FROM permittee_commodity1 WHERE permobjid = p.objid)
AND p.permitteename LIKE $P{searchtext}



[getList]
SELECT p.*, pc.objid as permitobjid, pc.* 
FROM permittee p
INNER JOIN permittee_commodity1 pc ON pc.permobjid = p.objid
WHERE pc.startdate = (SELECT MAX(startdate) FROM permittee_commodity1 WHERE permobjid = p.objid)
AND p.permitteename like $P{searchtext}

[findPermittee]
SELECT objid FROM permittee_commodity1 where permobjid = $P{permobjid} AND CURDATE() BETWEEN startdate AND enddate 

[findTotalQty]
SELECT pci.objid,SUM(xx.totalqty) AS totalqty FROM permittee_commodity_item pci
INNER JOIN (
SELECT pc.objid,SUM(poi.sgquantity) AS totalqty,sgk.commodityid FROM payorder p
INNER JOIN payorderitem poi ON poi.payorderid = p.objid
INNER JOIN sgkind_itemaccount si ON si.item_objid = poi.item_objid
INNER JOIN sgkind sgk ON sgk.objid = si.sgobjid
INNER JOIN permittee per ON per.objid = p.permobjid
INNER JOIN permittee_commodity1 pc ON pc.permobjid = per.objid 
INNER JOIN permittee_commodity_item pci ON pci.objid = pc.objid AND pci.commodityid = sgk.commodityid
WHERE
si.unit <> 0 AND
p.receiptdate BETWEEN pc.startdate AND pc.enddate
AND CURDATE() <= pc.enddate
AND pc.status <> 'Suspended'
AND p.state <> 'VOIDED'
AND pc.objid = $P{objid}
GROUP BY sgk.commodityid)xx ON xx.objid = pci.objid AND xx.commodityid = pci.commodityid
GROUP BY pci.objid

[getPermits]
SELECT pc.* 
FROM permittee_commodity1 pc 
WHERE pc.permobjid = $P{objid}

[getCommoditys]
select c.*
from permittee_commodity_item pci
INNER JOIN commodity c ON c.objid = pci.commodityid
where pci.objid = $P{objid}

[getSGKByCommoditys]
SELECT sgk.*,pc.eccallowed,xxx.totalqty FROM permittee_commodity1 pc
INNER JOIN permittee_commodity_item pci ON pci.objid = pc.objid
INNER JOIN sgkind sgk ON sgk.commodityid = pci.commodityid
INNER JOIN (
SELECT pci.objid,SUM(xx.totalqty) AS totalqty FROM permittee_commodity_item pci
INNER JOIN (
SELECT pc.objid,SUM(poi.sgquantity) AS totalqty,sgk.commodityid FROM payorder p
INNER JOIN payorderitem poi ON poi.payorderid = p.objid
INNER JOIN sgkind_itemaccount si ON si.item_objid = poi.item_objid
INNER JOIN sgkind sgk ON sgk.objid = si.sgobjid
INNER JOIN permittee per ON per.objid = p.permobjid
INNER JOIN permittee_commodity1 pc ON pc.permobjid = per.objid 
INNER JOIN permittee_commodity_item pci ON pci.objid = pc.objid AND pci.commodityid = sgk.commodityid
WHERE
si.unit <> 0 AND
p.receiptdate BETWEEN pc.startdate AND pc.enddate
AND CURDATE() <= pc.enddate
AND pc.status <> 'Suspended'
AND p.state <> 'VOIDED'
AND p.permobjid = $P{objid}
GROUP BY sgk.commodityid)xx ON xx.objid = pci.objid AND xx.commodityid = pci.commodityid
GROUP BY pci.objid)xxx ON xxx.objid = pc.objid
WHERE pc.permobjid = $P{objid}
AND CURDATE() <= pc.enddate
AND pc.status <> 'Suspended'
AND xxx.totalqty < pc.eccallowed

[getSGKByCommoditysNewPermittee]
SELECT sgk.* FROM permittee_commodity1 pc
INNER JOIN permittee_commodity_item pci ON pci.objid = pc.objid 
INNER JOIN sgkind sgk ON sgk.commodityid = pci.commodityid 
WHERE pc.permobjid = $P{objid} AND CURDATE() <= pc.enddate AND pc.status <> 'Suspended'

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

[getPermitteePayorder]
SELECT * FROM payorder WHERE permobjid = $P{permobjid}

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

[deleteitems]
delete from permittee_commodity_item where objid = $P{objid}

[findEccAllowed]
SELECT * FROM permittee_commodity1 WHERE objid = $P{objid}