prompt --application/set_environment
set define off verify off feedback off
whenever sqlerror exit sql.sqlcode rollback
--------------------------------------------------------------------------------
--
-- ORACLE Application Express (APEX) export file
--
-- You should run the script connected to SQL*Plus as the Oracle user
-- APEX_050100 or as the owner (parsing schema) of the application.
--
-- NOTE: Calls to apex_application_install override the defaults below.
--
--------------------------------------------------------------------------------
begin
wwv_flow_api.import_begin (
 p_version_yyyy_mm_dd=>'2016.08.24'
,p_release=>'5.1.4.00.08'
,p_default_workspace_id=>2940495016696413
,p_default_application_id=>100
,p_default_owner=>'HR'
);
end;
/
prompt --application/shared_components/plugins/region_type/at_rammelhof_apex_highcharts_serie
begin
wwv_flow_api.create_plugin(
 p_id=>wwv_flow_api.id(22813857515739363)
,p_plugin_type=>'REGION TYPE'
,p_name=>'AT.RAMMELHOF.APEX.HIGHCHARTS.SERIE'
,p_display_name=>'APEX Highcharts Serie'
,p_supported_ui_types=>'DESKTOP'
,p_image_prefix=>'&G_APEX_NITRO_IMAGES.'
,p_plsql_code=>wwv_flow_string.join(wwv_flow_t_varchar2(
'/*',
' * render - function to create placeholder div tag, and initialise the  component',
' */',
' function render ',
'( p_region                in  apex_plugin.t_region',
', p_plugin                in  apex_plugin.t_plugin',
', p_is_printer_friendly   in  boolean ',
') return apex_plugin.t_region_render_result ',
'is',
'  c_region_static_id constant varchar2(255)  := apex_escape.html_attribute( p_region.static_id );',
'  c_ajax_identifier constant varchar2(255) := apex_plugin.get_ajax_identifier;',
'  c_initFuncName constant varchar2(255) := ''initCustomHighchartsSerie_''||apex_escape.html_attribute( p_region.static_id );',
'  c_licensed constant varchar(16) := p_region.attribute_01;',
'  l_highcharts_version varchar2(16);',
'begin',
'  -- debug'',',
'  if v(''DEBUG'') = ''YES'' then',
'     apex_plugin_util.debug_region (p_plugin => p_plugin',
'                                  , p_region => p_region);',
'  end if;    ',
'  ',
'  -- Get highcharts collection values',
'  select ',
'    c001',
'  into',
'    l_highcharts_version',
'  from apex_collections',
'  where collection_name = ''HIGHCHARTS_COLLECTION'' and rownum=1;',
'  ',
'  -- add inline initialization code',
'  if p_region.init_javascript_code is not null then',
'      APEX_JAVASCRIPT.ADD_INLINE_CODE (',
'            p_code => ''var ''||c_initFuncName||'' = '' || p_region.init_javascript_code || '';'',',
'            p_key => ''apexHighchartsSerieInitCode''||c_region_static_id);    ',
'  else ',
'      APEX_JAVASCRIPT.ADD_INLINE_CODE (',
'            p_code => ''var ''||c_initFuncName||'' = function(serie){};'',',
'            p_key => ''apexHighchartsSerieInitCode''||c_region_static_id);    ',
'  end if;  ',
'',
'  -- add css',
'  apex_css.add (',
'    p_css => ''#''||c_region_static_id||'' { display:none; }'',',
'    p_key => ''apexHighchartsSerieInitCodeCSS''||c_region_static_id );',
'',
'  -- add highcharts modules',
'  APEX_JAVASCRIPT.ADD_LIBRARY (',
'        p_name => ''coloraxis.js'',',
'        p_directory => case when l_highcharts_version = ''latest'' then ''https://code.highcharts.com/modules/'' else ''https://code.highcharts.com/''||l_highcharts_version||''/modules/'' end,',
'        p_skip_extension => true,',
'        p_key => ''highcharts_coloraxis''',
'      );',
'  if p_region.attribute_01 = ''sunburst'' then',
'      APEX_JAVASCRIPT.ADD_LIBRARY (',
'        p_name => ''sunburst.js'',',
'        p_directory => case when l_highcharts_version = ''latest'' then ''https://code.highcharts.com/modules/'' else ''https://code.highcharts.com/''||l_highcharts_version||''/modules/'' end,',
'        p_skip_extension => true,',
'        p_key => ''highcharts_sunburst''',
'      );',
'  end if;',
'  if p_region.attribute_01 = ''wordcloud'' then',
'      APEX_JAVASCRIPT.ADD_LIBRARY (',
'        p_name => ''wordcloud.js'',',
'        p_directory => case when l_highcharts_version = ''latest'' then ''https://code.highcharts.com/modules/'' else ''https://code.highcharts.com/''||l_highcharts_version||''/modules/'' end,',
'        p_skip_extension => true,',
'        p_key => ''highcharts_wordcloud''',
'      );',
'  end if;',
'  if p_region.attribute_01 = ''timeline'' then',
'      APEX_JAVASCRIPT.ADD_LIBRARY (',
'        p_name => ''timeline.js'',',
'        p_directory => case when l_highcharts_version = ''latest'' then ''https://code.highcharts.com/modules/'' else ''https://code.highcharts.com/''||l_highcharts_version||''/modules/'' end,',
'        p_skip_extension => true,',
'        p_key => ''highcharts_timeline''',
'      );',
'  end if;',
'  if p_region.attribute_01 = ''heatmap'' then',
'      APEX_JAVASCRIPT.ADD_LIBRARY (',
'        p_name => ''heatmap.js'',',
'        p_directory => case when l_highcharts_version = ''latest'' then ''https://code.highcharts.com/modules/'' else ''https://code.highcharts.com/''||l_highcharts_version||''/modules/'' end,',
'        p_skip_extension => true,',
'        p_key => ''highcharts_heatmap''',
'      );',
'  end if;',
'  if p_region.attribute_01 = ''solidgauge'' then',
'      APEX_JAVASCRIPT.ADD_LIBRARY (',
'        p_name => ''solid-gaugesolid-gauge.js'',',
'        p_directory => case when l_highcharts_version = ''latest'' then ''https://code.highcharts.com/modules/'' else ''https://code.highcharts.com/''||l_highcharts_version||''/modules/'' end,',
'        p_skip_extension => true,',
'        p_key => ''highcharts_solidgauge''',
'      );',
'  end if;',
'  if p_region.attribute_01 in (''funnel'',''pyramid'') then',
'      APEX_JAVASCRIPT.ADD_LIBRARY (',
'        p_name => ''funnel.js'',',
'        p_directory => case when l_highcharts_version = ''latest'' then ''https://code.highcharts.com/'' else ''https://code.highcharts.com/''||l_highcharts_version||''/'' end,',
'        p_skip_extension => true,',
'        p_key => ''highcharts_funnel''',
'      );',
'  end if;',
'  if p_region.attribute_01 in (''bubble'',''packedbubble'',''gauge'',''polygon'') then',
'      APEX_JAVASCRIPT.ADD_LIBRARY (',
'        p_name => ''highcharts-more.js'',',
'        p_directory => case when l_highcharts_version = ''latest'' then ''https://code.highcharts.com/'' else ''https://code.highcharts.com/''||l_highcharts_version||''/'' end,',
'        p_skip_extension => true,',
'        p_key => ''highcharts_more''',
'      );',
'  end if;',
'  ',
'',
'  -- Add placeholder div',
'  sys.htp.p (',
'     ''<div class="div-APEX-Highcharts-Serie" id="'' || c_region_static_id || ''_region" ajax-id="''||c_ajax_identifier||''" initCode="''||c_initFuncName||''">'' ||',
'     ''</div>'' );',
'     ',
'  return null;',
'end render;',
'',
'/*',
' * ajax - function to process SQL query, and output JSON data for chart',
' */',
'function ajax',
'( p_region    in  apex_plugin.t_region',
', p_plugin    in  apex_plugin.t_plugin ',
') return apex_plugin.t_region_ajax_result',
'is',
'  c       sys_refcursor;',
'  l_query varchar2(32767);',
'  l_vc_arr2 APEX_APPLICATION_GLOBAL.VC_ARR2;',
'begin  ',
'  l_query := p_region.source;',
'  ',
'  -- replace bind varibles :variable with V(''variable'')',
'  l_vc_arr2 := APEX_UTIL.STRING_TO_TABLE(p_region.ajax_items_to_submit,'','');',
'  FOR z IN 1..l_vc_arr2.count LOOP',
'    l_query := replace(l_query, '':'' || trim(l_vc_arr2(z)), ''V(''''''||trim(l_vc_arr2(z))||'''''')'');',
'  END LOOP;',
'  ',
'  -- debug'',',
'  if v(''DEBUG'') = ''YES'' then',
'      apex_debug.info(''Run serie query for region %s'', p_region.name);',
'      apex_debug.info(l_query);',
'  end if;    ',
'',
'  open c for l_query;',
'',
'  apex_json.open_object;',
'  if p_region.attribute_25 = ''full'' then',
'      apex_json.write(''series'', c);',
'  else',
'      apex_json.write(''data'', c);',
'  end if;',
'  apex_json.write(''name'', p_region.name);',
'  apex_json.write(''type'', p_region.attribute_01);',
'  apex_json.write(''color'', p_region.attribute_02);',
'  apex_json.write(''query_type'', p_region.attribute_25);',
'  apex_json.close_object;',
'',
'  return null;',
'exception',
'  when others then',
'      if SQLCODE = -911 then',
'          apex_json.open_object;',
'          apex_json.write(''error'', ''Invalid character. Try remove ; at and of PL/SQL query.'');',
'          apex_json.close_object;',
'      else ',
'          apex_json.open_object;',
'          apex_json.write(''error'', SQLERRM);',
'          apex_json.close_object;',
'      end if;',
'      return null;',
'end ajax;'))
,p_api_version=>2
,p_render_function=>'render'
,p_ajax_function=>'ajax'
,p_standard_attributes=>'SOURCE_SQL:AJAX_ITEMS_TO_SUBMIT:INIT_JAVASCRIPT_CODE'
,p_substitute_attributes=>true
,p_subscribe_plugin_settings=>true
,p_version_identifier=>'0.1'
,p_about_url=>'https://github.com/rhinterndorfer/APEX-Highcharts'
,p_files_version=>20
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(22822310767007183)
,p_plugin_id=>wwv_flow_api.id(22813857515739363)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>1
,p_display_sequence=>10
,p_prompt=>'Serie type'
,p_attribute_type=>'SELECT LIST'
,p_is_required=>true
,p_default_value=>'spline'
,p_is_translatable=>false
,p_lov_type=>'STATIC'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(22824336469025449)
,p_plugin_attribute_id=>wwv_flow_api.id(22822310767007183)
,p_display_sequence=>10
,p_display_value=>'area'
,p_return_value=>'area'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(22823971386022061)
,p_plugin_attribute_id=>wwv_flow_api.id(22822310767007183)
,p_display_sequence=>20
,p_display_value=>'bar'
,p_return_value=>'bar'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(22889947462438554)
,p_plugin_attribute_id=>wwv_flow_api.id(22822310767007183)
,p_display_sequence=>30
,p_display_value=>'bubble'
,p_return_value=>'bubble'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(22823519994016740)
,p_plugin_attribute_id=>wwv_flow_api.id(22822310767007183)
,p_display_sequence=>40
,p_display_value=>'column'
,p_return_value=>'column'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(23034063668805282)
,p_plugin_attribute_id=>wwv_flow_api.id(22822310767007183)
,p_display_sequence=>45
,p_display_value=>'gauge'
,p_return_value=>'gauge'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(22897729135545768)
,p_plugin_attribute_id=>wwv_flow_api.id(22822310767007183)
,p_display_sequence=>50
,p_display_value=>'heatmap'
,p_return_value=>'heatmap'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(22824908896033037)
,p_plugin_attribute_id=>wwv_flow_api.id(22822310767007183)
,p_display_sequence=>60
,p_display_value=>'line'
,p_return_value=>'line'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(22953633512821877)
,p_plugin_attribute_id=>wwv_flow_api.id(22822310767007183)
,p_display_sequence=>65
,p_display_value=>'packedbubble'
,p_return_value=>'packedbubble'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(22903603558624238)
,p_plugin_attribute_id=>wwv_flow_api.id(22822310767007183)
,p_display_sequence=>70
,p_display_value=>'pie'
,p_return_value=>'pie'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(23048078700820904)
,p_plugin_attribute_id=>wwv_flow_api.id(22822310767007183)
,p_display_sequence=>72
,p_display_value=>'polygon'
,p_return_value=>'polygon'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(23038807166812974)
,p_plugin_attribute_id=>wwv_flow_api.id(22822310767007183)
,p_display_sequence=>75
,p_display_value=>'pyramid'
,p_return_value=>'pyramid'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(22908882157697980)
,p_plugin_attribute_id=>wwv_flow_api.id(22822310767007183)
,p_display_sequence=>80
,p_display_value=>'scatter'
,p_return_value=>'scatter'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(23057234103830595)
,p_plugin_attribute_id=>wwv_flow_api.id(22822310767007183)
,p_display_sequence=>85
,p_display_value=>'solidgauge'
,p_return_value=>'solidgauge'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(22822995190008584)
,p_plugin_attribute_id=>wwv_flow_api.id(22822310767007183)
,p_display_sequence=>90
,p_display_value=>'spline'
,p_return_value=>'spline'
,p_is_quick_pick=>true
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(22880024220164840)
,p_plugin_attribute_id=>wwv_flow_api.id(22822310767007183)
,p_display_sequence=>100
,p_display_value=>'sunburst'
,p_return_value=>'sunburst'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(22898173879570524)
,p_plugin_attribute_id=>wwv_flow_api.id(22822310767007183)
,p_display_sequence=>110
,p_display_value=>'timeline'
,p_return_value=>'timeline'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(22898580351579364)
,p_plugin_attribute_id=>wwv_flow_api.id(22822310767007183)
,p_display_sequence=>120
,p_display_value=>'wordcloud'
,p_return_value=>'wordcloud'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(22825555055040390)
,p_plugin_id=>wwv_flow_api.id(22813857515739363)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>2
,p_display_sequence=>20
,p_prompt=>'Color'
,p_attribute_type=>'COLOR'
,p_is_required=>true
,p_default_value=>'#000000'
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(22971100564556468)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'EQUALS'
,p_depending_on_expression=>'data'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(22971100564556468)
,p_plugin_id=>wwv_flow_api.id(22813857515739363)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>25
,p_display_sequence=>15
,p_prompt=>'Query type'
,p_attribute_type=>'SELECT LIST'
,p_is_required=>true
,p_default_value=>'data'
,p_is_translatable=>false
,p_lov_type=>'STATIC'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(22975312835559075)
,p_plugin_attribute_id=>wwv_flow_api.id(22971100564556468)
,p_display_sequence=>10
,p_display_value=>'Data'
,p_return_value=>'data'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(22975755539559902)
,p_plugin_attribute_id=>wwv_flow_api.id(22971100564556468)
,p_display_sequence=>20
,p_display_value=>'Full'
,p_return_value=>'full'
);
wwv_flow_api.create_plugin_std_attribute(
 p_id=>wwv_flow_api.id(22818250570739395)
,p_plugin_id=>wwv_flow_api.id(22813857515739363)
,p_name=>'INIT_JAVASCRIPT_CODE'
,p_is_required=>false
);
wwv_flow_api.create_plugin_std_attribute(
 p_id=>wwv_flow_api.id(22818626930739396)
,p_plugin_id=>wwv_flow_api.id(22813857515739363)
,p_name=>'SOURCE_SQL'
);
end;
/
begin
wwv_flow_api.import_end(p_auto_install_sup_obj => nvl(wwv_flow_application_install.get_auto_install_sup_obj, false), p_is_component_import => true);
commit;
end;
/
set verify on feedback on define on
prompt  ...done
