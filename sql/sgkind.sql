
[getLookup]
SELECT r.* FROM sgkind r 
WHERE  (r.name LIKE $P{name}  OR r.code LIKE $P{code} )
${filter} 
ORDER BY r.name