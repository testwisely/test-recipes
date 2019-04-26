# recipes for generate xlsx

  def write_excel_write_xlsx()           
    output_file = File.join( output_dir(), "sample-report.xlsx")
    workbook = WriteXLSX.new(output_file)    
    blue_cell = workbook.add_format(:bg_color => "#92a8d1", :bold => true)
    
    sheet1 = workbook.add_worksheet("Records")
    sheet1.write_row(0, 0, ["ID", "Score"])
    @data.each_with_index do |entry, idx|            
      sheet1.write_row(idx + 1, 0, entry)       
        sheet1.write(idx + 1, 4, 1, blue_cell)        
        sheet1.write(idx + 1, 4, 0)        
        
    sheet2 = workbook.add_worksheet("Charts")    
    bold = workbook.add_format(:bold => true)

    sheet2.write(0, 0, "11")
    sheet2.write(0, 1,  "22" , bold)  
    sheet2.write_row(1, 0, ["1",  "2", "3", "4"])
    sheet2.write_row(1, 0, ["2",  "2", "3", "4"], bold)
    
    chart = workbook.add_chart(:type => 'pie', :embedded => 1)
    chart.add_series( 
      :categories => [ 'Charts', 1, 1, 0, 3],
      :values     => [ 'Charts', 2, 2, 0, 3]
    )
    chart.set_title(:name => "Record Count")
    chart.set_style(10)
    sheet2.insert_chart("A5", chart, 1, 1)
    
    workbook.close
  end
  
  
 # max 65336 rows for spreadseet gem
    
  def write_excel_axlsx()
    
    ac3_rows = []
    ac4_rows = []
    ac5_rows = []
    ac6_rows = []
    
    xp = Axlsx::Package.new
    xp.use_autowidth = true  # default and has to be true
    wb = xp.workbook

    wb.styles do |s|
      blue_cell = s.add_style  :bg_color => "92a8d1"
      bold      = s.add_style  :b => true
      
      # Records
      wb.add_worksheet(:name => "Records") do |sheet|
        sheet.add_row ["ID", "Score"]
        @ac2_data.each_with_index do |entry, idx|                      
          the_row = entry
          sheet.add_row(entry)                 
        end
        ac3_rows.each {|idx| sheet["E#{idx+2}:E#{idx+2}"].each{ |c| c.style = blue_cell } }
        ac4_rows.each {|idx| sheet["F#{idx+2}:F#{idx+2}"].each{ |c| c.style = blue_cell } }
        ac5_rows.each {|idx| sheet["G#{idx+2}:G#{idx+2}"].each{ |c| c.style = blue_cell } }
        ac6_rows.each {|idx| sheet["H#{idx+2}:H#{idx+2}"].each{ |c| c.style = blue_cell } }          
      end

      # Pie Chart                           
      wb.add_worksheet(:name => "Pie Chart") do |sheet|
        
        #date_time = sheet.styles.add_style(:num_fmt => Axlsx::NUM_FMT_YYYYMMDDHHMMSS, :border=>Axlsx::STYLE_THIN_BORDER)
        #percent = sheet.styles.add_style(:num_fmt => Axlsx::NUM_FMT_PERCENT, :border=>Axlsx::STYLE_THIN_BORDER)
        #currency = sheet.styles.add_style(:format_code=>"¥#,##0;[Red]¥-#,##0", :border=>Axlsx::STYLE_THIN_BORDER)          
                            
        sheet.add_row ["1", @ac2_data.count], :style => [nil, bold]
        sheet.add_row ["2",  "3", "4", "5"]
        sheet.add_row [5,6,7, 8], :style => [bold, bold, bold, bold]
        
        sheet.add_chart(Axlsx::Pie3DChart, :start_at => [0,4], :end_at => [4, 16], :title=> 'Stats') do |chart|
          chart.add_series :data => sheet["A3:D3"], :labels => sheet["A2:D2"]
          chart.d_lbls.show_val = true
          chart.d_lbls.show_percent = true
          chart.d_lbls.d_lbl_pos = :outEnd
          chart.d_lbls.show_leader_lines = true
        end
      
      end

    end
    
    output_file = File.join(output_dir(), "sample-report.xlsx")
    xp.serialize(output_file)    
  end
  
  def write_excel_xlsxtream()        
    output_file = File.join( output_dir(), "report-stream.xlsx")
    Xlsxtream::Workbook.open(output_file) do |xlsx|
      xlsx.write_worksheet(name: 'Records', use_shared_strings: true) do |sheet|
        sheet << ["ID", "SCORE"]        
        @ac2_data.each_with_index do |entry, idx|            
          print("[Count] #{idx}\r") if idx % 1000 == 0 # for displaying progress indicator
          the_row = entry          
          pbd_id = entry.first
          sheet << the_row
        end
      end
      
      xlsx.write_worksheet 'Pie Chart' do |sheet|
        sheet <<  ["1", 100]
        sheet << ["2",  "3", "4", "5"]
        sheet << [5, 6, 7, 8]
      end
  
    end
  end
