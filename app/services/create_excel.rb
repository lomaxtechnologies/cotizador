class CreateExcel

    def create
        workbook = RubyXL::Workbook.new
        worksheet= workbook.worksheet[0]
        worksheet.insert_row(0)
        worksheet.insert_row(1)
        worksheet.insert_row(2)
        worksheet[2].insert_column(0)
        worksheet[2].insert_column(1)
        worksheet[2].insert_column(2)
        worksheet[2].insert_column(3)
        worksheet[2].insert_column(4)
        worksheet[2].insert_column(5)
        workbook.write("storage/prueba.xlsx")
    end
end