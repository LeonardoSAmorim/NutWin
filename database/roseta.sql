SELECT * FROM mynutwin.medparte mp inner join mynutwin.medcorpo mc on mp.medida = mc.psensivel;
SELECT * FROM mynutwin.objvis o inner join mynutwin.medcorpo mc on o.objeto = mc.corpo;
SELECT * FROM mynutwin.objvis o inner join mynutwin.vista v on o.objeto = v.objeto;
select * from mynutwin.vista v inner join mynutwin.areavist av on av.objeto = v.objeto;
select * from mynutwin.areaclic ac inner join mynutwin.areavist av on ac.ovarea = av.ovarea;
select * from mynutwin.areaclic ac inner join mynutwin.cursores c on ac.ovcursor = c.ovcursor;
SELECT * FROM mynutwin.sxagebdy s inner join mynutwin.objvis o on s.corpo = o.objeto;
select * from mynutwin.faixaetaria f inner join mynutwin.sxagebdy s on f.nomeslot = s.faixaetaria;
select * from mynutwin.dscrfnt df right outer join mynutwin.dscrtrs dt on df.fonte = dt.fonte;
select * from mynutwin.dscrtrs dt right outer join mynutwin.dscrqntv dq on dq.coddscr = dt.codigo;
select * from mynutwin.tmedida t inner join mynutwin.dscrqntv dq on t.name = dq.valordependente;
select * from mynutwin.tmedida t inner join mynutwin.dscrqntv dq on t.name = dq.varindependente;
select * from mynutwin.dscrtrs dt inner join mynutwin.dscrparm dp on dp.coddscr = dt.codigo;
select * from mynutwin.dscrtrs dt inner join mynutwin.dscrnumval dn on dn.dscrld = dt.codigo;
select * from mynutwin.cnut c inner join mynutwin.cnut_pf cpf on c.cod_cnut = cpf.codfilho_cnut;
SELECT * FROM mynutwin.cnut_pf pai inner join mynutwin.cnut_pf filho on pai.codpai_cnut = filho.codfilho_cnut;


SELECT * FROM mynutwin.calcali c;
SELECT * FROM mynutwin.itensali i;
SELECT * FROM mynutwin.refcalcali r;
-- Escolher uma chave
-- 'calcali.id_calcali', 'refcalcali.id_refeicao' 'itensali.id_calcali'
--     foreign key em itensali
--     'itensali.id_calcali', 'refcalcali.id_refeicao'
--     'itensali.id_calcali', 'calcali.id_calcali'

select distinct a.y, b.y from (

SELECT guid x, 'aliconv.guid' y FROM aliconv
union
SELECT idali,'aligcal.idali' FROM aligcal
union
SELECT idali, 'aligprot.idali' FROM aligprot
union
SELECT idgruprot, 'aligprot.idgruprot' FROM aligprot
union
SELECT idmedcas, 'aligprot.idmedcas' FROM aligprot
union
SELECT idali, 'alimento.idali' FROM alimento
union
SELECT idorig, 'alimento.idorig' FROM alimento
union
SELECT idgruali, 'alimento.idgruali' FROM alimento
union
SELECT idali, 'alinut.idali' FROM alinut
union
SELECT idnut, 'alinut.idnut' FROM alinut
union
SELECT idorig, 'aliorg.idorig' FROM aliorg
union
SELECT idali, 'alipreco.idali' FROM alipreco
union
SELECT idpessoa, 'anamnese.idpessoa' FROM anamnese
union
SELECT idpessoa, 'antrops.idpessoa' FROM antrops
union
SELECT idpasta, 'cadpastas.idpasta' FROM cadpastas
union
SELECT idpessoa, 'cadpastas.idpessoa' FROM cadpastas
union
SELECT guid, 'ativfis.guid' FROM ativfis
union
SELECT idpasta, 'cadpastas.idpasta' FROM cadpastas
union
SELECT idpessoa, 'cadpastas.idpessoa' FROM cadpastas
union
SELECT guid, 'calcali.guid' FROM calcali
union
SELECT id_calcali, 'calcali.id_calcali' FROM calcali
union
SELECT idcid, 'cidade.idcid' FROM cidade
union
SELECT codcor, 'cor.codcor' FROM cor
union
SELECT coddica, 'dicas.coddica' FROM dicas
union
SELECT idpessoa, 'dietas.idpessoa' FROM dietas
union
SELECT idpessoa, 'endereco.idpessoa' FROM endereco
union
SELECT idestado, 'estado.idestado' FROM estado
union
SELECT idpessoa, 'exapess.idpessoa' FROM exapess
union
SELECT idgruali, 'galical.idgruali' FROM galical
union
SELECT idgrucal, 'galical.idgrucal' FROM galical
union
SELECT idgruali, 'galiprot.idgruali' FROM galiprot
union
SELECT idgruprot, 'galiprot.idgruprot' FROM galiprot
union
SELECT idgruali, 'gruali.idgruali' FROM gruali
union
SELECT idgrucal, 'grucal.idgrucal' FROM grucal
union
SELECT idgruprot, 'gruprot.idgruprot' FROM gruprot
union
SELECT idpessoa, 'inqueritos.idpessoa' FROM inqueritos
union
SELECT codinstruc, 'instrucao.codinstruc' FROM instrucao
union
SELECT guid, 'itensali.guid' FROM itensali
union
SELECT id_calcali, 'itensali.id_calcali' FROM itensali
union
SELECT id_refeicao, 'itensali.id_refeicao' FROM itensali
union
SELECT id_ali, 'itensali.id_ali' FROM itensali
union
SELECT id_medida, 'itensali.id_medida' FROM itensali
union
SELECT idgruali, 'itensali.idgruali' FROM itensali
union
SELECT id_refeicao, 'listarefeicao.id_refeicao' FROM listarefeicao
union
SELECT id_modref, 'listarefeicao.id_modref' FROM listarefeicao
union
SELECT idmacronut, 'macronut.idmacronut' FROM macronut
union
SELECT idali, 'medidacaseira.idali' FROM medidacaseira
union
SELECT idmedcas, 'medidacaseira.idmedcas' FROM medidacaseira
union
SELECT idmedcas, 'medidas.idmedcas' FROM medidas
union
SELECT id_modref, 'modrefeicao.id_modref' FROM modrefeicao
union
SELECT idnac, 'nacionalidade.idnac' FROM nacionalidade
union
SELECT idnut, 'nut.idnut' FROM nut
union
SELECT idorig, 'nut.idorig' FROM nut
union
SELECT guid, 'nutconv.guid' FROM nutconv
union
SELECT idopcoes, 'opcoes.idopcoes' FROM opcoes
union
SELECT naturalidade, 'opcoes.naturalidade' FROM opcoes
union
SELECT nacionalidade, 'opcoes.nacionalidade' FROM opcoes
union
SELECT cor, 'opcoes.cor' FROM opcoes
union
SELECT cidade, 'opcoes.cidade' FROM opcoes
union
SELECT idpasta, 'pastas.idpasta' FROM pastas
union
SELECT idpessoa, 'pesscomp.idpessoa' FROM pesscomp
union
SELECT codnatural, 'pesscomp.codnatural' FROM pesscomp
union
SELECT codnacional, 'pesscomp.codnacional' FROM pesscomp
union
SELECT codcor, 'pesscomp.codcor' FROM pesscomp
union
SELECT codprofis, 'pesscomp.codprofis' FROM pesscomp
union
SELECT codinstruc, 'pesscomp.codinstruc' FROM pesscomp
union
SELECT idpessoa, 'pessoa.idpessoa' FROM pessoa
union
SELECT codprofis, 'profissao.codprofis' FROM profissao
union
SELECT idnut, 'rda.idnut' FROM rda
union
SELECT idnut, 'rdagn.idnut' FROM rdagn
union
SELECT guid, 'refcalcali.guid' FROM refcalcali
union
SELECT id_calcali, 'refcalcali.id_refeicao' FROM refcalcali
union
SELECT id_refeicao, 'refcalcali.id_refeicao' FROM refcalcali
union
SELECT id_refeicao, 'refeicao.id_refeicao' FROM refeicao
union
SELECT idpessoa, 'telefone.idpessoa' FROM telefone
) a,
(

SELECT guid x, 'aliconv.guid' y FROM aliconv
union
SELECT idali,'aligcal.idali' FROM aligcal
union
SELECT idali, 'aligprot.idali' FROM aligprot
union
SELECT idgruprot, 'aligprot.idgruprot' FROM aligprot
union
SELECT idmedcas, 'aligprot.idmedcas' FROM aligprot
union
SELECT idali, 'alimento.idali' FROM alimento
union
SELECT idorig, 'alimento.idorig' FROM alimento
union
SELECT idgruali, 'alimento.idgruali' FROM alimento
union
SELECT idali, 'alinut.idali' FROM alinut
union
SELECT idnut, 'alinut.idnut' FROM alinut
union
SELECT idorig, 'aliorg.idorig' FROM aliorg
union
SELECT idali, 'alipreco.idali' FROM alipreco
union
SELECT idpessoa, 'anamnese.idpessoa' FROM anamnese
union
SELECT idpessoa, 'antrops.idpessoa' FROM antrops
union
SELECT idpasta, 'cadpastas.idpasta' FROM cadpastas
union
SELECT idpessoa, 'cadpastas.idpessoa' FROM cadpastas
union
SELECT guid, 'ativfis.guid' FROM ativfis
union
SELECT idpasta, 'cadpastas.idpasta' FROM cadpastas
union
SELECT idpessoa, 'cadpastas.idpessoa' FROM cadpastas
union
SELECT guid, 'calcali.guid' FROM calcali
union
SELECT id_calcali, 'calcali.id_calcali' FROM calcali
union
SELECT idcid, 'cidade.idcid' FROM cidade
union
SELECT codcor, 'cor.codcor' FROM cor
union
SELECT coddica, 'dicas.coddica' FROM dicas
union
SELECT idpessoa, 'dietas.idpessoa' FROM dietas
union
SELECT idpessoa, 'endereco.idpessoa' FROM endereco
union
SELECT idestado, 'estado.idestado' FROM estado
union
SELECT idpessoa, 'exapess.idpessoa' FROM exapess
union
SELECT idgruali, 'galical.idgruali' FROM galical
union
SELECT idgrucal, 'galical.idgrucal' FROM galical
union
SELECT idgruali, 'galiprot.idgruali' FROM galiprot
union
SELECT idgruprot, 'galiprot.idgruprot' FROM galiprot
union
SELECT idgruali, 'gruali.idgruali' FROM gruali
union
SELECT idgrucal, 'grucal.idgrucal' FROM grucal
union
SELECT idgruprot, 'gruprot.idgruprot' FROM gruprot
union
SELECT idpessoa, 'inqueritos.idpessoa' FROM inqueritos
union
SELECT codinstruc, 'instrucao.codinstruc' FROM instrucao
union
SELECT guid, 'itensali.guid' FROM itensali
union
SELECT id_calcali, 'itensali.id_calcali' FROM itensali
union
SELECT id_refeicao, 'itensali.id_refeicao' FROM itensali
union
SELECT id_ali, 'itensali.id_ali' FROM itensali
union
SELECT id_medida, 'itensali.id_medida' FROM itensali
union
SELECT idgruali, 'itensali.idgruali' FROM itensali
union
SELECT id_refeicao, 'listarefeicao.id_refeicao' FROM listarefeicao
union
SELECT id_modref, 'listarefeicao.id_modref' FROM listarefeicao
union
SELECT idmacronut, 'macronut.idmacronut' FROM macronut
union
SELECT idali, 'medidacaseira.idali' FROM medidacaseira
union
SELECT idmedcas, 'medidacaseira.idmedcas' FROM medidacaseira
union
SELECT idmedcas, 'medidas.idmedcas' FROM medidas
union
SELECT id_modref, 'modrefeicao.id_modref' FROM modrefeicao
union
SELECT idnac, 'nacionalidade.idnac' FROM nacionalidade
union
SELECT idnut, 'nut.idnut' FROM nut
union
SELECT idorig, 'nut.idorig' FROM nut
union
SELECT guid, 'nutconv.guid' FROM nutconv
union
SELECT idopcoes, 'opcoes.idopcoes' FROM opcoes
union
SELECT naturalidade, 'opcoes.naturalidade' FROM opcoes
union
SELECT nacionalidade, 'opcoes.nacionalidade' FROM opcoes
union
SELECT cor, 'opcoes.cor' FROM opcoes
union
SELECT cidade, 'opcoes.cidade' FROM opcoes
union
SELECT idpasta, 'pastas.idpasta' FROM pastas
union
SELECT idpessoa, 'pesscomp.idpessoa' FROM pesscomp
union
SELECT codnatural, 'pesscomp.codnatural' FROM pesscomp
union
SELECT codnacional, 'pesscomp.codnacional' FROM pesscomp
union
SELECT codcor, 'pesscomp.codcor' FROM pesscomp
union
SELECT codprofis, 'pesscomp.codprofis' FROM pesscomp
union
SELECT codinstruc, 'pesscomp.codinstruc' FROM pesscomp
union
SELECT idpessoa, 'pessoa.idpessoa' FROM pessoa
union
SELECT codprofis, 'profissao.codprofis' FROM profissao
union
SELECT idnut, 'rda.idnut' FROM rda
union
SELECT idnut, 'rdagn.idnut' FROM rdagn
union
SELECT guid, 'refcalcali.guid' FROM refcalcali
union
SELECT id_calcali, 'refcalcali.id_refeicao' FROM refcalcali
union
SELECT id_refeicao, 'refcalcali.id_refeicao' FROM refcalcali
union
SELECT id_refeicao, 'refeicao.id_refeicao' FROM refeicao
union
SELECT idpessoa, 'telefone.idpessoa' FROM telefone
) b where a.x = b.x and a.y <> b.y order by a.y, b.y