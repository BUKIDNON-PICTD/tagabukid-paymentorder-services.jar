[getPermitteeCumulativeQuantity]
SELECT pc.objid, 
per.`permitteename`,
p.`receiptdate`, 
p.`receiptno`,
p.`amountdue`, 
SUM(poi.sgquantity) AS totalqty, 
sgk.`name`, 
sgk.commodityid,
pc.`startdate`,
pc.`enddate`,
pc.`permitno` FROM payorder p
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
GROUP BY p.`receiptno`
ORDER BY p.`receiptdate` DESC