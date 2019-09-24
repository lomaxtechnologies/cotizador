module ApplicationHelper
  def paging_array(current_page,total_pages,max_size=9)
    if total_pages == 1
      return {1 => true}
    end
    array = Hash.new
    array[1] = false
    array[total_pages] = false

    max_size-=2
    total_pages-=2
    step = total_pages / max_size.to_f

    page = 1
    max_size.times do
      page+=step
      array[page.round] = false
    end

    array[current_page] = true

    return array.sort.to_h

  end
end
