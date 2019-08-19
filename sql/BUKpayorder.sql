[getList]
select * 
from payorder
where (ordernum like $P{searchtext}
or paidby like $P{searchtext}
or paidbyaddress like $P{searchtext}
or state like $P{searchtext}
or amountdue like $P{searchtext}
or receiptno like $P{searchtext}
or txndate like $P{searchtext})
and objid NOT IN (SELECT objid FROM payorder WHERE expdate < NOW() AND state = 'DRAFT')

[getAccounts]
select * 
from payorderitem

[getColumns]
select * 
from payorder

[getPayorderitems]
select *
from payorderitem
where payorderid = $P{objid}

[getPayorders]
select * 
from payorder
where ordernum like $P{searchtext}

[closePayorder]
update payorder set receiptid = $P{receiptid}, receiptno = $P{receiptno}, receiptdate = $P{receiptdate}, state = 'CLOSED', username = $P{username}
where objid = $P{payorderid}

[closePayorderVoid]
update payorder set state = 'VOIDED'
where receiptid = $P{receiptid}

[getLookupList]
select * 
from payorder
where state <> 'CLOSED' and (
ordernum like $P{searchtext}
or paidby like $P{searchtext}
or paidbyaddress like $P{searchtext}
or state like $P{searchtext}
or amountdue like $P{searchtext}
or receiptno like $P{searchtext} )
and NOW() <= expdate

[getSGAdminList]
SELECT pt.objid, p.paidby, p.paidbyaddress, pt.item_title, p.ordernum, p.txndate, pt.amount, p.receiptno, pt.couponno 
FROM payorder p
INNER JOIN payorderitem pt ON p.objid = pt.payorderid
INNER JOIN sgkind_itemaccount sgk ON sgk.item_objid = pt.item_objid
WHERE sgk.txntype like '%EXTRACTION%'
and p.paidby like $P{searchtext};

[updateCoupon]
update payorderitem set couponno = $P{couponno}
where objid = $P{objid}

[getCouponno]
select * 
from payorderitem
where couponno = $P{couponno}

[getPayorderitemsx]
SELECT xx.*, IFNULL(CEIL(xx.newquantity/xx.unit),0) AS newcoupon FROM
(SELECT p.objid, p.ordernum, p.amountdue, p.username, p.receiptno, p.receiptdate,
 pt.objid AS ptobjid, pt.payorderid, pt.item_title, pt.amount, pt.couponno,
sgk.unittype,
sgk.unit,
pt.sgquantity AS newquantity,
pt.defaultvalue,
sgk.txntype
FROM simple_payment_order3.payorder p
INNER JOIN simple_payment_order3.payorderitem pt ON p.objid = pt.payorderid 
INNER JOIN simple_payment_order3.sgkind_itemaccount sgk ON sgk.item_objid = pt.item_objid
WHERE pt.payorderid = $P{objid}) xx

[getOrePayorderitemsx]
SELECT poi.sgquantity, poi.item_title, poi.defaultvalue, poi.amount
FROM simple_payment_order3.payorder po
INNER JOIN simple_payment_order3.payorderitem poi ON poi.payorderid = po.objid
WHERE poi.payorderid = $P{objid}

[getSGKindAccount]
SELECT * FROM sgkind_itemaccount  
WHERE sgobjid = $P{objid} AND orseq = $P{orseq}

[getSGKindAccountorseq]
SELECT DISTINCT orseq FROM sgkind_itemaccount
WHERE sgobjid IN ${filter}

[getItemAccount]
SELECT * FROM itemaccount
WHERE objid = $P{objid}

[getSGKindAccountAll]
SELECT * FROM sgkind_itemaccount  
WHERE sgobjid = $P{objid}

[getHousingReport]
SELECT po.objid, po.paidby, po.paidbyaddress, po.receiptdate, po.receiptno,po.receiptid,po.amountdue
FROM payorder po
WHERE po.office = 'Housing' AND po.receiptdate BETWEEN $P{startdate} AND $P{enddate}  
ORDER BY po.receiptdate;

[getHousingReportItem]
SELECT payorderid, item_title, remarks, amount 
FROM payorderitem
WHERE payorderid = $P{objid}

[getVoidedReceipt]
SELECT * FROM cashreceipt_void WHERE ${filter}

[getReceiptNo]
SELECT * FROM payorder
where receiptno = $P{receiptno}

[findCurrentSeries]
SELECT nextSeries AS currentSeries FROM sys_sequence WHERE objid = $P{objid} 

[getValidReceiptno]
SELECT m.receiptno FROM etracs254_bukidnonns.cashreceipt m
WHERE receiptno = $P{receiptno}

[getTransferTaxItemAccounts]
select * from itemaccount where description = $P{description} 

[getTransferTaxPayorderitems]
select poi.item_title, poi.amount from simple_payment_order3.payorder po
inner join simple_payment_order3.payorderitem poi on poi.payorderid = po.objid
where poi.payorderid = $P{objid}

[getMonthDiff]
select timestampdiff(month,  $P{lastdatepaid}, CURDATE());