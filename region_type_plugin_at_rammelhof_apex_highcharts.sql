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
prompt --application/shared_components/plugins/region_type/at_rammelhof_apex_highcharts
begin
wwv_flow_api.create_plugin(
 p_id=>wwv_flow_api.id(68332273227969832)
,p_plugin_type=>'REGION TYPE'
,p_name=>'AT.RAMMELHOF.APEX.HIGHCHARTS'
,p_display_name=>'APEX Highcharts'
,p_supported_ui_types=>'DESKTOP'
,p_image_prefix=>'&G_APEX_NITRO_IMAGES.'
,p_javascript_file_urls=>'#PLUGIN_FILES#APEXHighcharts.js'
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
'  c_initFuncName constant varchar2(255) := ''initCustomHighchartsOptions_''||apex_escape.html_attribute( p_region.static_id );',
'  c_licensed constant varchar2(16) := p_region.attribute_01;',
'  c_highcharts_version constant varchar2(16) := p_region.attribute_25;',
'begin',
'  -- debug'',',
'  if v(''DEBUG'') = ''YES'' then',
'     apex_plugin_util.debug_region (p_plugin => p_plugin',
'                                  , p_region => p_region);',
'  end if;    ',
'  -- Add collection',
'  if not apex_collection.collection_exists(''HIGHCHARTS_COLLECTION'') then ',
'    apex_collection.create_collection(''HIGHCHARTS_COLLECTION'');',
'  end if;',
'  if APEX_COLLECTION.COLLECTION_MEMBER_COUNT(''HIGHCHARTS_COLLECTION'') = 0 then',
'      apex_collection.add_member(',
'        p_collection_name => ''HIGHCHARTS_COLLECTION'',',
'        p_c001 =>            c_highcharts_version',
'      );',
'  end if;',
'',
'  -- Add libraries',
'  APEX_JAVASCRIPT.ADD_LIBRARY (',
'    p_name => ''highcharts.js'',',
'    p_directory => case when c_highcharts_version = ''latest'' then ''https://code.highcharts.com/'' else ''https://code.highcharts.com/''||c_highcharts_version||''/'' end,',
'    p_skip_extension => true,',
'    p_key => ''highcharts''',
'  );',
'  APEX_JAVASCRIPT.ADD_LIBRARY (',
'    p_name => ''exporting.js'',',
'    p_directory => case when c_highcharts_version = ''latest'' then ''https://code.highcharts.com/modules/'' else ''https://code.highcharts.com/''||c_highcharts_version||''/modules/'' end,',
'    p_skip_extension => true,',
'    p_key => ''highcharts_exporting''',
'  );',
'  ',
'',
'  -- Add placeholder div',
'  if c_licensed != ''YES'' then',
'      sys.htp.p (''Unlicensed! Please obtain a highchart license for your application from <a href="https://shop.highsoft.com">shop.highsoft.com</a> and set the "Licensed" option for the plugin to "Yes"'');',
'  end if;',
'  sys.htp.p (',
'     ''<div class="div-APEX-Highcharts" id="'' || c_region_static_id || ''_region">'' ||',
'       ''<div class="div-APEX-Highcharts-container" id="'' || c_region_static_id || ''_chart"></div>'' ||',
'     ''</div>'' );',
'  ',
'  -- add inline initialization code',
'  if p_region.init_javascript_code is not null then',
'      APEX_JAVASCRIPT.ADD_INLINE_CODE (',
'            p_code => ''var ''||c_initFuncName||'' = '' || p_region.init_javascript_code || '';'',',
'            p_key => ''apexHighchartsInitCode''||c_region_static_id);    ',
'  else ',
'      APEX_JAVASCRIPT.ADD_INLINE_CODE (',
'            p_code => ''var ''||c_initFuncName||'' = function(option){};'',',
'            p_key => ''apexHighchartsInitCode''||c_region_static_id);    ',
'  end if;  ',
'  ',
'  ',
'  -- Initialize the chart',
'  apex_javascript.add_onload_code(p_code => ''apexHighcharts.chart.init("#''||c_region_static_id||''","''||c_ajax_identifier||''",initCustomHighchartsOptions_''||c_region_static_id||'')'');',
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
'  apex_json.open_object;',
'',
'  if l_query is not null then',
'      -- replace bind varibles :variable with V(''variable'')',
'      l_vc_arr2 := APEX_UTIL.STRING_TO_TABLE(p_region.ajax_items_to_submit,'','');',
'      FOR z IN 1..l_vc_arr2.count LOOP',
'        l_query := replace(l_query, '':'' || trim(l_vc_arr2(z)), ''V(''''''||trim(l_vc_arr2(z))||'''''')'');',
'      END LOOP;',
'      ',
'      open c for l_query;',
'      apex_json.write(''chartOptions'', c);',
'  end if;',
'',
'  apex_json.write(''title'', p_region.attribute_02);',
'  apex_json.write(''display_legend'', p_region.attribute_03);',
'  apex_json.write(''allow_exporting'', p_region.attribute_04);',
'  apex_json.write(''background_color'', p_region.attribute_05);',
'  apex_json.write(''zoom_type'', p_region.attribute_06);',
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
,p_files_version=>25
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(68348052689264489)
,p_plugin_id=>wwv_flow_api.id(68332273227969832)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>1
,p_display_sequence=>10
,p_prompt=>'Highcharts licensed'
,p_attribute_type=>'SELECT LIST'
,p_is_required=>true
,p_default_value=>'NO'
,p_is_translatable=>false
,p_lov_type=>'STATIC'
,p_help_text=>'When settings to "Yes" you confirm that you have optained a license from https://shop.highsoft.com/ for you purpose of use.'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(68348640911266368)
,p_plugin_attribute_id=>wwv_flow_api.id(68348052689264489)
,p_display_sequence=>10
,p_display_value=>'No, I have not optained a highcharts license.'
,p_return_value=>'NO'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(68349177941268517)
,p_plugin_attribute_id=>wwv_flow_api.id(68348052689264489)
,p_display_sequence=>20
,p_display_value=>'Yes, I have optained a highcharts license.'
,p_return_value=>'YES'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(22827629003067425)
,p_plugin_id=>wwv_flow_api.id(68332273227969832)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>2
,p_display_sequence=>20
,p_prompt=>'Title'
,p_attribute_type=>'TEXT'
,p_is_required=>false
,p_is_translatable=>false
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(22874177135032852)
,p_plugin_id=>wwv_flow_api.id(68332273227969832)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>3
,p_display_sequence=>30
,p_prompt=>'Display legend'
,p_attribute_type=>'CHECKBOX'
,p_is_required=>false
,p_default_value=>'N'
,p_is_translatable=>false
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(22875338857038349)
,p_plugin_id=>wwv_flow_api.id(68332273227969832)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>4
,p_display_sequence=>40
,p_prompt=>'Allow exporting'
,p_attribute_type=>'CHECKBOX'
,p_is_required=>false
,p_default_value=>'N'
,p_is_translatable=>false
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(22885874523379824)
,p_plugin_id=>wwv_flow_api.id(68332273227969832)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>5
,p_display_sequence=>50
,p_prompt=>'Background color'
,p_attribute_type=>'COLOR'
,p_is_required=>true
,p_default_value=>'#FFFFFF'
,p_is_translatable=>false
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(22958943600164978)
,p_plugin_id=>wwv_flow_api.id(68332273227969832)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>6
,p_display_sequence=>60
,p_prompt=>'Zoom type'
,p_attribute_type=>'SELECT LIST'
,p_is_required=>true
,p_default_value=>'NONE'
,p_is_translatable=>false
,p_lov_type=>'STATIC'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(22960136751165880)
,p_plugin_attribute_id=>wwv_flow_api.id(22958943600164978)
,p_display_sequence=>10
,p_display_value=>'None'
,p_return_value=>'NONE'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(22960557763166902)
,p_plugin_attribute_id=>wwv_flow_api.id(22958943600164978)
,p_display_sequence=>20
,p_display_value=>'XY'
,p_return_value=>'xy'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(22960956824168663)
,p_plugin_attribute_id=>wwv_flow_api.id(22958943600164978)
,p_display_sequence=>30
,p_display_value=>'X'
,p_return_value=>'x'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(22961340510169266)
,p_plugin_attribute_id=>wwv_flow_api.id(22958943600164978)
,p_display_sequence=>40
,p_display_value=>'Y'
,p_return_value=>'y'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(22843860102230878)
,p_plugin_id=>wwv_flow_api.id(68332273227969832)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>25
,p_display_sequence=>250
,p_prompt=>'Highcharts version'
,p_attribute_type=>'SELECT LIST'
,p_is_required=>true
,p_default_value=>'8.0'
,p_is_translatable=>false
,p_lov_type=>'STATIC'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(22845023931231532)
,p_plugin_attribute_id=>wwv_flow_api.id(22843860102230878)
,p_display_sequence=>10
,p_display_value=>'8.0'
,p_return_value=>'8.0'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(22848312763259101)
,p_plugin_attribute_id=>wwv_flow_api.id(22843860102230878)
,p_display_sequence=>15
,p_display_value=>'8.0.4'
,p_return_value=>'8.0.4'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(22847120327255918)
,p_plugin_attribute_id=>wwv_flow_api.id(22843860102230878)
,p_display_sequence=>99
,p_display_value=>'Latest'
,p_return_value=>'latest'
);
wwv_flow_api.create_plugin_std_attribute(
 p_id=>wwv_flow_api.id(68332894410969869)
,p_plugin_id=>wwv_flow_api.id(68332273227969832)
,p_name=>'INIT_JAVASCRIPT_CODE'
,p_is_required=>false
);
wwv_flow_api.create_plugin_std_attribute(
 p_id=>wwv_flow_api.id(68332477689969866)
,p_plugin_id=>wwv_flow_api.id(68332273227969832)
,p_name=>'SOURCE_SQL'
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '2F2F2076657273696F6E20302E310D0A212066756E6374696F6E202861706578486967686368617274732C20242C207365727665722C207574696C2C20646562756729207B0D0A202020202275736520737472696374223B0D0A0D0A2020202061706578';
wwv_flow_api.g_varchar2_table(2) := '486967686368617274732E6368617274203D207B0D0A2020202020202020696E69743A2066756E6374696F6E202870526567696F6E53656C6563746F722C207041706578416A61784964656E7469666965722C20696E6974436F646543616C6C6261636B';
wwv_flow_api.g_varchar2_table(3) := '29207B0D0A202020202020202020202020636F6E736F6C652E6C6F672860496E69742068696768636861727420666F7220726567696F6E20247B70526567696F6E53656C6563746F727D20616E6420616A617820247B7041706578416A61784964656E74';
wwv_flow_api.g_varchar2_table(4) := '69666965727D60293B0D0A2020202020202020202020200D0A202020202020202020202020242870526567696F6E53656C6563746F72292E6F6E28226170657872656672657368222C66756E6374696F6E28297B0D0A2020202020202020202020202020';
wwv_flow_api.g_varchar2_table(5) := '202061706578486967686368617274732E63686172742E6C6F61642870526567696F6E53656C6563746F722C207041706578416A61784964656E7469666965722C20696E6974436F646543616C6C6261636B293B0D0A2020202020202020202020207D29';
wwv_flow_api.g_varchar2_table(6) := '3B0D0A0D0A20202020202020202020202061706578486967686368617274732E63686172742E6C6F61642870526567696F6E53656C6563746F722C207041706578416A61784964656E7469666965722C20696E6974436F646543616C6C6261636B293B0D';
wwv_flow_api.g_varchar2_table(7) := '0A20202020202020207D2C0D0A20202020202020206C6F61643A2066756E6374696F6E2870526567696F6E53656C6563746F722C207041706578416A61784964656E7469666965722C20696E6974436F646543616C6C6261636B297B0D0A202020202020';
wwv_flow_api.g_varchar2_table(8) := '202020202020636F6E736F6C652E6C6F6728604C6F616420686967686368617274206461746120666F7220726567696F6E20247B70526567696F6E53656C6563746F727D60293B0D0A2020202020202020202020207365727665722E706C7567696E2870';
wwv_flow_api.g_varchar2_table(9) := '41706578416A61784964656E7469666965722C207B7D2C207B0D0A20202020202020202020202020202020737563636573733A2066756E6374696F6E2028704461746129207B0D0A2020202020202020202020202020202020202020636F6E736F6C652E';
wwv_flow_api.g_varchar2_table(10) := '6C6F67287044617461293B0D0A202020202020202020202020202020202020202061706578486967686368617274732E63686172742E72656E6465722870526567696F6E53656C6563746F722C2070446174612C20696E6974436F646543616C6C626163';
wwv_flow_api.g_varchar2_table(11) := '6B293B0D0A202020202020202020202020202020207D0D0A2020202020202020202020207D293B0D0A20202020202020207D2C0D0A202020202020202072656E6465723A2066756E6374696F6E2870526567696F6E53656C6563746F722C207044617461';
wwv_flow_api.g_varchar2_table(12) := '2C20696E6974436F646543616C6C6261636B29207B0D0A202020202020202020202020636F6E736F6C652E6C6F67286052656E6465722068696768636861727420666F7220726567696F6E20247B70526567696F6E53656C6563746F727D60293B0D0A20';
wwv_flow_api.g_varchar2_table(13) := '20202020202020202020200D0A20202020202020202020202076617220686967686368617274734F7074696F6E203D20486967686368617274732E6765744F7074696F6E7328293B0D0A202020202020202020202020686967686368617274734F707469';
wwv_flow_api.g_varchar2_table(14) := '6F6E2E6368617274203D20686967686368617274734F7074696F6E2E6368617274207C7C207B7D3B0D0A202020202020202020202020686967686368617274734F7074696F6E2E63726564697473203D20686967686368617274734F7074696F6E2E6372';
wwv_flow_api.g_varchar2_table(15) := '6564697473207C7C207B7D3B0D0A202020202020202020202020686967686368617274734F7074696F6E2E7469746C65203D20686967686368617274734F7074696F6E2E7469746C65207C7C207B7D3B0D0A202020202020202020202020686967686368';
wwv_flow_api.g_varchar2_table(16) := '617274734F7074696F6E2E6C6567656E64203D20686967686368617274734F7074696F6E2E6C6567656E64207C7C207B7D3B0D0A202020202020202020202020686967686368617274734F7074696F6E2E6578706F7274696E67203D2068696768636861';
wwv_flow_api.g_varchar2_table(17) := '7274734F7074696F6E2E6578706F7274696E67207C7C207B7D3B0D0A0D0A0D0A202020202020202020202020686967686368617274734F7074696F6E2E63686172742E72656E646572546F203D20242870526567696F6E53656C6563746F72202B20225F';
wwv_flow_api.g_varchar2_table(18) := '636861727422295B305D3B0D0A2020202020202020202020202F2F2073657474696E67730D0A202020202020202020202020686967686368617274734F7074696F6E2E637265646974732E656E61626C6564203D2066616C73653B0D0A0D0A2020202020';
wwv_flow_api.g_varchar2_table(19) := '20202020202020686967686368617274734F7074696F6E2E63686172742E6261636B67726F756E64436F6C6F72203D2070446174612E6261636B67726F756E645F636F6C6F723B0D0A202020202020202020202020686967686368617274734F7074696F';
wwv_flow_api.g_varchar2_table(20) := '6E2E63686172742E7A6F6F6D54797065203D2070446174612E7A6F6F6D5F74797065203D3D20224E4F4E4522203F20756E646566696E6564203A2070446174612E7A6F6F6D5F747970653B0D0A0D0A202020202020202020202020686967686368617274';
wwv_flow_api.g_varchar2_table(21) := '734F7074696F6E2E7469746C652E74657874203D2070446174612E7469746C653B0D0A202020202020202020202020686967686368617274734F7074696F6E2E7469746C652E766572746963616C416C69676E203D2027746F70273B0D0A202020202020';
wwv_flow_api.g_varchar2_table(22) := '2020202020200D0A202020202020202020202020686967686368617274734F7074696F6E2E6C6567656E642E656E61626C6564203D2070446174612E646973706C61795F6C6567656E64203D3D20224E22203F2066616C7365203A20747275653B0D0A20';
wwv_flow_api.g_varchar2_table(23) := '20202020202020202020200D0A202020202020202020202020686967686368617274734F7074696F6E2E6578706F7274696E672E656E61626C6564203D2070446174612E616C6C6F775F6578706F7274696E67203D3D20224E22203F2066616C7365203A';
wwv_flow_api.g_varchar2_table(24) := '20747275653B0D0A0D0A2020202020202020202020200D0A2020202020202020202020202F2F2064796E616D69632073657474696E67730D0A202020202020202020202020766172207573657243686172744F7074696F6E203D2070446174612E636861';
wwv_flow_api.g_varchar2_table(25) := '72744F7074696F6E735B305D3B0D0A202020202020202020202020686967686368617274734F7074696F6E203D20486967686368617274732E6D6572676528686967686368617274734F7074696F6E2C207573657243686172744F7074696F6E293B0D0A';
wwv_flow_api.g_varchar2_table(26) := '2020202020202020202020200D0A2020202020202020202020200D0A202020202020202020202020696628696E6974436F646543616C6C6261636B297B0D0A20202020202020202020202020202020696E6974436F646543616C6C6261636B2868696768';
wwv_flow_api.g_varchar2_table(27) := '6368617274734F7074696F6E293B0D0A2020202020202020202020207D0D0A0D0A202020202020202020202020766172206368617274203D206E657720486967686368617274732E436861727428686967686368617274734F7074696F6E293B0D0A0D0A';
wwv_flow_api.g_varchar2_table(28) := '2020202020202020202020202F2F20616464207365726965730D0A202020202020202020202020242870526567696F6E53656C6563746F72292E66696E6428272E6469762D415045582D486967686368617274732D536572696527292E65616368286675';
wwv_flow_api.g_varchar2_table(29) := '6E6374696F6E28692C20656C656D656E74297B0D0A2020202020202020202020202020202076617220616A61784964203D202428656C656D656E74292E617474722827616A61782D696427293B0D0A202020202020202020202020202020207661722069';
wwv_flow_api.g_varchar2_table(30) := '6E6974436F646546756E63537472203D202428656C656D656E74292E617474722827696E6974436F646527293B0D0A2020202020202020202020202020202076617220656C656D656E744964203D202428656C656D656E74292E61747472282769642729';
wwv_flow_api.g_varchar2_table(31) := '3B0D0A20202020202020202020202020202020636F6E736F6C652E6C6F6728604C6F61642068696768636861727420736572696520666F7220726567696F6E20247B656C656D656E7449647D60293B0D0A20202020202020202020202020202020736572';
wwv_flow_api.g_varchar2_table(32) := '7665722E706C7567696E28616A617849642C207B7D2C207B0D0A2020202020202020202020202020202020202020737563636573733A2066756E6374696F6E2028704461746129207B0D0A20202020202020202020202020202020202020202020202061';
wwv_flow_api.g_varchar2_table(33) := '706578486967686368617274732E63686172742E61646453657269652863686172742C2070446174612C20696E6974436F646546756E63537472293B0D0A20202020202020202020202020202020202020207D0D0A202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(34) := '207D293B0D0A2020202020202020202020207D293B0D0A20202020202020207D2C0D0A202020202020202061646453657269653A2066756E6374696F6E287043686172742C2070446174612C2070496E6974436F646546756E63537472297B0D0A202020';
wwv_flow_api.g_varchar2_table(35) := '202020202020202020636F6E736F6C652E6C6F67287044617461293B0D0A202020202020202020202020766172207365726965203D207043686172742E6164645365726965732870446174612C2066616C73652C2074727565293B0D0A20202020202020';
wwv_flow_api.g_varchar2_table(36) := '20202020207661722066756E63203D206E65772046756E6374696F6E282272657475726E20222B70496E6974436F646546756E63537472293B0D0A20202020202020202020202066756E632829287365726965293B0D0A20202020202020202020202070';
wwv_flow_api.g_varchar2_table(37) := '43686172742E72656472617728293B0D0A20202020202020207D0D0A202020207D0D0A7D2877696E646F772E6170657848696768636861727473203D2077696E646F772E6170657848696768636861727473207C7C207B7D2C20617065782E6A51756572';
wwv_flow_api.g_varchar2_table(38) := '792C20617065782E7365727665722C20617065782E7574696C2C20617065782E6465627567293B';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(68333771393307311)
,p_plugin_id=>wwv_flow_api.id(68332273227969832)
,p_file_name=>'APEXHighcharts.js'
,p_mime_type=>'application/x-javascript'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
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
