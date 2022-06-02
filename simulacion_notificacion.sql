INSERT INTO veterquimica_minerales_dev.notificacion
(num_op,folio,origen,cod_material,peso_teorico_batch,peso_real_batch,estado_notificacion,estado_batch,tiempo_real_mezclado,cod_componente_poch,cod_componente,desc_componente,peso_teorico_componente,
peso_real_componente,peso_real_notificable,unidad_base,factor_conversion,tolva,lote,fecha_inicio_dosificacion,fecha_fin_dosificacion,hora_inicio_dosificacion,hora_fin_dosificacion,flags_ingrediente,
tstamp_insercion,correlativo_orden)
select
bc.num_op,bc.folio,'SAP' origen,bc.cod_material,
bc.peso_teorico peso_teorico_batch,
bc.peso_teorico peso_real_batch,
6 estado_notificacion, 0 estado_batch, 0 tiempo_real_mezclado,
bd.cod_componente cod_componente_poch,
dc.alias cod_componente, dc.descripcion desc_componente,
bd.consumo_teorico peso_teorico_componente,
bd.consumo_teorico peso_real_componente,
bd.consumo_teorico peso_real_notificable,
dc.unidad_base, dc.factor_conversion,
100 + @row_num := @row_num + 1 tolva,
COALESCE(cs.lote, '0000999999') lote,
'2022/05/27' fecha_inicio_dosificacion,
'2022/05/27' fecha_fin_dosificacion,
'00:00:01' hora_inicio_dosificacion,
'00:00:59' hora_fin_dosificacion,
0 flags_ingrediente,
now() tstamp_insercion,
30 + @row_num correlativo_orden
from batch_cabecera bc
left join (select @row_num := 0) r on 1=1
left join batch_detalle bd on bc.folio = bd.folio
left join diccionario_componentes dc on bd.cod_componente = dc.cod_componente
left join (
select cod_componente, min(lote) lote from control_stock group by cod_componente
) cs on dc.alias = cs.cod_componente
where bc.num_op = 1084860
and bc.folio = 6;

