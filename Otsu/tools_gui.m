function tools_gui(choice,handle1,handle2)
if choice == 's'
    ang = get(handle1,'Value');
    ang = uint8(ang);
    set(handle1,'Value',ang);
    set(handle2,'String',num2str(ang)); %将滑块值输出到编辑框中
elseif choice =='e'
    [a,x] = str2num(get(handle1,'String'));
    if x == 0
        a = 0;
    else
        a = int16(a(1));
        if a < 0
            a = 0;
        elseif a > 255
            a = 255;
        end
    end
    set(handle1,'String',a);
    set(handle2,'Value',a);
end