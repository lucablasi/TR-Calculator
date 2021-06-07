function TR_Calculator_16K
%Calculador super avanzado de TRs.
%Creado por:
%Luca Blasi
%Débora Reyes
%Julieta Mascaro
%Lucas Suarez Hatfield

try
appdata = get(0,'ApplicationData');
a = fieldnames(appdata);
for ii = 1:numel(a)
  rmappdata(0,a{ii});
end

f = figure('Visible','off','Position',[0 0 1000 500],'Resize','off');

handles.e = figure('Visible','off','Position',[0 0 200 100],...
    'Resize','off','CloseRequestFcn',@MyRequest);
handles.error = uicontrol(handles.e,'Style','text','Position',[20 70 160 50],...
    'String','Algo hiciste mal de tu lado, porque el codigo es perfecto.',...
    'FontName','Trebuchet MS','FontSize',10);
handles.errorok = uicontrol(handles.e,'Style','pushbutton','String','Ufa',...
    'Position',[25 20 150 30],'FontName','Trebuchet MS',...
    'Callback',{@errorok_Callback, handles});
movegui(handles.e,'center');
handles.e.Name = '';
handles.e.MenuBar = 'none';
handles.e.NumberTitle = 'off';

handles.help1 = uicontrol(f,'Style','text','Position',[800 430 100 40],...
    'String','Primero importate tus mediciones','ForegroundColor','b');
handles.help2 = uicontrol(f,'Style','text','Position',[800 370 100 50],...
    'String','Si querés podes cambiar los parámetros del Sine Sweep');
handles.help3 = uicontrol(f,'Style','text','Position',[800 300 100 50],...
    'String','Ahora apretá "Calculate!"');
handles.help4 = uicontrol(f,'Style','text','Position',[790 250 120 50],...
    'String',{'Podés usar','"Plot & Table"'});

handles.ax = axes(f,'Units','Pixels','Position',[60 50 470 460],...
    'XLim',[0,2],'YLim',[-45 0]);
xlabel(handles.ax,'Tiempo [s]');
ylabel(handles.ax,'Amplitud [dBFS]');

filetext = uicontrol(f,'Style', 'text','String','Seleccionar archivo',...
    'Position',[560 460 120 25]);
handles.fileselect = uicontrol(f,'Style','popupmenu','Position',[560 470 120 0],...
    'String','Importar archivos');

bandtext = uicontrol(f,'Style', 'text','String','Seleccionar banda [Hz]',...
    'Position',[560 360 120 25]);
handles.bandselect = uicontrol(f,'Style','popupmenu','Position',[560 370 120 0],...
    'String',{'31.5','63','125','250','500','1000','2000','4000','8000','16000'});

filttext = uicontrol(f,'Style', 'text',...
    'String','Seleccionar tipo de filtro','Position',[560 410 120 25]);
handles.filtselect = uicontrol(f,'Style','popupmenu','Position',[560 420 120 0],...
    'String',{'por octava','por tercio de octava'},...
    'Callback',{@filtselect_Callback, handles});


handles.tabletext = uicontrol(f,'Style','text',...
    'Position',[560 150 250 30],...
    'String','Descriptores promedio entre muestras','FontSize',10);
handles.table = uitable(f,'Position',[560 50 410 110],...
    'RowName',{'EDT','T10','T20','T30'},...
    'ColumnName',{'b1','b2','b3','b4','b5','b6','b7','b8','b9','...'});

handles.g = figure('Visible','off','Position',[0 0 260 140],'Resize','off',...
    'CloseRequestFcn',@MyRequest);

    handles.g_f1 = uicontrol(handles.g,'Style','edit','Position',[140 150 100 20],...
        'String','88');
    handles.g_f2 = uicontrol(handles.g,'Style','edit','Position',[140 120 100 20],...
        'String','11314');
    handles.g_T = uicontrol(handles.g,'Style','edit','Position',[140 90 100 20],...
        'String','30');
    handles.g_ti = uicontrol(handles.g,'Style','edit','Position',[140 60 100 20],...
        'String','1');

    g_f1_text = uicontrol(handles.g,'Style','text','Position',[20 150 100 20],...
        'FontName','Trebuchet MS','HorizontalAlignment','right',...
        'String','Frecuencia inicial:');
    g_f2_text = uicontrol(handles.g,'Style','text','Position',[20 120 100 20],...
        'FontName','Trebuchet MS','HorizontalAlignment','right',...
        'String','Frecuencia final:');
    g_T_text = uicontrol(handles.g,'Style','text','Position',[20 90 100 20],...
        'FontName','Trebuchet MS','HorizontalAlignment','right',...
        'String','Duración:');
    g_ti_text = uicontrol(handles.g,'Style','text','Position',[20 60 100 20],...
        'FontName','Trebuchet MS','HorizontalAlignment','right',...
        'String','Silencio inicial:');
    ok = uicontrol(handles.g,'Style','pushbutton','Position',[260/3 20 260/3 30],...
    'String','Ok!','FontName','Trebuchet MS',...
    'Callback',{@ok_Callback, handles});
    
    movegui(handles.g,'center');
    handles.g.Name = 'Parámetros';
    handles.g.MenuBar = 'none';
    handles.g.NumberTitle = 'off';
    
handles.calc_text = uicontrol(f,'Style','text',...
    'Position',[690 277 120 40],'HorizontalAlignment','left',...
    'String','');    
    
calculate = uicontrol(f,'Style','pushbutton','Position',[560 290 120 40],...
'String','Calculate!','FontName','Trebuchet MS',...
'Callback',{@calculate_Callback, handles});

graph = uicontrol(f,'Style','pushbutton','Position',[560 240 120 40],...
'String','Plot & Table!','FontName','Trebuchet MS',...
'Callback',{@graph_Callback, handles});

mfile = uimenu(f,'Label','Archivo');
mfile1 = uimenu(mfile,'Label','Importar mediciones',...
    'Callback',{@GetFilesM, handles});
mfile2 = uimenu(mfile,'Label','Importar respuesta al impulso',...
    'Callback',{@GetFilesH, handles});
mSine = uimenu(f,'Label','Sine Sweep','Callback',{@mSine_Callback, handles});

movegui(f,'center');
f.Name = 'TR Calculator 16K';
f.MenuBar = 'none';
f.NumberTitle = 'off';
f.Visible = 'on';
catch
     set(handles.e,'Visible','on');
end

%-------------------------------------------------------------------------%
%FUNCIONES

function GetFilesM(~,~,handles)
%Para que el usuario seleccione los archivos de las mediciones.
%Se tienen que seleccionar todos juntos.
%Los archivos se audioredean y su salida se guarda en la estructura s.
%En el caso de que se elija un solo archivo entra como character, no como
%cell, por eso hay un if para cada caso, pero el resultado es el mismo.
%Algo para notar es que se toma la fs de la primera muestra, lo cual no
%está completamente bien.

try
[filename, pathname] = uigetfile({'*.wav';'*.mat'},...
    'Seleccione todas las mediciones','Multiselect','on');
pathfile = strcat(pathname,filename);
a = ischar(filename);
    if a == 1
        set(handles.fileselect,'String',filename);
        [s.med.m1,s.fs] = audioread(pathfile);
    else
        set(handles.fileselect,'String',char(filename));
        [x,fs] = cellfun(@audioread,pathfile,'UniformOutput',0);
        n = numel(x);
        for i = 1:n
            s.med.(sprintf('m%d',i)) = x{i};
        end
    s.fs = fs{1};
    end
    check = 0;
    setappdata(0,'check',check);
    setappdata(0,'s',s);
        if get(handles.help2,'ForegroundColor')==[0.75 0.75 0.75]
            set(handles.help1,'ForegroundColor',[0.75 0.75 0.75]);
            set(handles.help3,'ForegroundColor','b');
        else
            set(handles.help1,'ForegroundColor',[0.75 0.75 0.75]);
            set(handles.help2,'ForegroundColor','b');
        end
    catch
     set(handles.error,'String','Mmm... me parece que no elegiste nada.');
     set(handles.e,'Visible','on');
end
end

%-------------------------------------------------------------------------%

function GetFilesH(~,~,handles)
%Para que el usuario seleccione las respuestas al impulso
%Se tienen que seleccionar todos juntos.

try
[filename, pathname] = uigetfile({'*.wav';'*.mat'},...
    'Seleccione todas las respuestas al impulso','Multiselect','on');
pathfile = strcat(pathname,filename);
a = ischar(filename);
    if a == 1
        set(handles.fileselect,'String',filename);
        [s.h.m1,s.fs] = audioread(pathfile);
    else
        set(handles.fileselect,'String',char(filename));
        [x,fs] = cellfun(@audioread,pathfile,'UniformOutput',0);
        n = numel(x);
        for i = 1:n
            s.h.(sprintf('m%d',i)) = x{i};
        end
    s.fs = fs{1};
    end
    check = 1;
    setappdata(0,'check',check);
    setappdata(0,'s',s);
        if get(handles.help2,'ForegroundColor')==[0.75 0.75 0.75]
            set(handles.help1,'ForegroundColor',[0.75 0.75 0.75]);
            set(handles.help3,'ForegroundColor','b');
        else
            set(handles.help1,'ForegroundColor',[0.75 0.75 0.75]);
            set(handles.help2,'ForegroundColor','b');
        end
    catch
     set(handles.error,'String','Mmm... me parece que no elegiste nada.');
     set(handles.e,'Visible','on');
end
end

%-------------------------------------------------------------------------%

function filtselect_Callback(object_handle,~,handles)
%Cambia el string de bandselect para adecuarse a la opcion seleccionada
%en filtselect

try
    switch get(object_handle,'Value')
        case 1
        set(handles.bandselect,'Value',1);
        set(handles.bandselect,'String',{'31.5','63','125','250','500',...
            '1000','2000','4000','8000','16000'});
        case 2
        set(handles.bandselect,'Value',1);
        set(handles.bandselect,'String',{'28.5','32','36','57','64',...
            '71.8','111.3','125','140.3','222.7','250','280.6','445.5',...
            '500','561','890.9','1000','1122.46','1781.79','2000',...
            '2244.92','3563.59','4000','4489.84','7127.19','8000',...
            '8979.7','14254.4','16000','17959.4'});
    end
    catch
     set(handles.e,'Visible','on');
end
end

%-------------------------------------------------------------------------%

function mSine_Callback(~,~,handles)
%Hace visible la ventana de los parámetros sine sweep
try
set(handles.g,'Visible','on');
catch
     set(handles.e,'Visible','on');
end
end

%-------------------------------------------------------------------------%

function calculate_Callback(~,~,handles)
%Calcula TODO
    
try
    set(handles.calc_text,'String','Procesando datos...');
    drawnow update
    check = getappdata(0,'check');
    if check == 0    
        f1 = str2double(get(handles.g_f1,'String'));
        f2 = str2double(get(handles.g_f2,'String'));
        T  = str2double(get(handles.g_T,'String'));
        ti = str2double(get(handles.g_ti,'String'));
        s = getappdata(0,'s');
        s = RespImp(s,f1,f2,T,ti);
    end
    s = Cut(s);
    s = Lundy(s);
    s = Filter(s);
    s = Smooth(s);
    s = Plotter(s);
    s = DBFS(s);
    s = TR(s);
    v = Convert(s);
    v = Promedio(v);
    v = Tablatize(v);
    setappdata(0,'s',s);
    setappdata(0,'v',v);
    set(handles.calc_text,'String','Datos procesados!');
    handles.help2.ForegroundColor = [0.75 0.75 0.75];
    handles.help3.ForegroundColor = [0.75 0.75 0.75];
    handles.help4.ForegroundColor = 'b';
    catch
     set(handles.calc_text,'String','');
     set(handles.e,'Visible','on');
end
end

%-------------------------------------------------------------------------%

function graph_Callback(~,~,handles)
%Update de plot y tabla segun selecciones de popup

try
s = getappdata(0,'s');
v = getappdata(0,'v');
i = get(handles.filtselect,'Value');
j = get(handles.bandselect,'Value');
k = get(handles.fileselect,'Value');

if i==2
    i=3;
end

fs = s.fs;
x    = s.(sprintf('plotter%d',i)).(sprintf('b%dm%d',j,k));
sch  = s.(sprintf('DB%d',i)).(sprintf('b%dm%d',j,k));
n    = 1/fs:1/fs:length(x)/fs;
nEDT = s.(sprintf('nEDT%d',i)).(sprintf('b%dm%d',j,k));
pEDT = s.(sprintf('pEDT%d',i)).(sprintf('b%dm%d',j,k));
rEDT = pEDT(1)*nEDT+pEDT(2);
nT10 = s.(sprintf('nT10%d',i)).(sprintf('b%dm%d',j,k));
pT10 = s.(sprintf('pT10%d',i)).(sprintf('b%dm%d',j,k));
rT10 = pT10(1)*nT10+pT10(2);
nT20 = s.(sprintf('nT20%d',i)).(sprintf('b%dm%d',j,k));
pT20 = s.(sprintf('pT20%d',i)).(sprintf('b%dm%d',j,k));
rT20 = pT20(1)*nT20+pT20(2);
nT30 = s.(sprintf('nT30%d',i)).(sprintf('b%dm%d',j,k));
pT30 = s.(sprintf('pT30%d',i)).(sprintf('b%dm%d',j,k));
rT30 = pT30(1)*nT30+pT30(2);

cla
plot(n,x,':','LineWidth',1);
hold on;
plot(n,sch,'--','LineWidth',1);
xlim([n(1),nT30(end)]);
ylim([-45,0]);
plot(nEDT,rEDT,'LineWidth',1);
plot(nT10,rT10,'LineWidth',1);
plot(nT20,rT20,'LineWidth',1);
plot(nT30,rT30,'LineWidth',1);
xlabel('Tiempo [s]');ylabel('Amplitud [dBFS]');
legend('Envolvente','Schroeder Decay','EDT','T10','T20','T30');

switch i
    case 1
        set(handles.table,'ColumnName',{'31.5','63','125','250',...
            '500','1000','2000','4000','8000','16000'});
    case 3
        set(handles.table,'ColumnName',{'28.5','32','36','57','64',...
            '71.8','111.3','125','140.3','222.7','250','280.6','445.5',...
            '500','561','890.9','1000','1122.46','1781.79','2000',...
            '2244.92','3563.59','4000','4489.84','7127.19','8000',...
            '8979.7','14254.4','16000','17959.4'});
end
set(handles.table,'Data',v.(sprintf('Tabla%d',i)));
handles.help4.ForegroundColor = [0.75 0.75 0.75];
catch
     set(handles.error,'String','¿Puede ser que te hayas salteado unos pasos?');
     set(handles.e,'Visible','on');
end
end

%-------------------------------------------------------------------------%

function MyRequest(object_handle,~,~)
set(object_handle,'Visible','off');
end

%-------------------------------------------------------------------------%

function ok_Callback(~,~,handles)
    
try
handles.g.Visible = 'off';
movegui(handles.g,'center');
    if get(handles.help1,'ForegroundColor')==[0 0 1]
       set(handles.help2,'ForegroundColor',[0.75 0.75 0.75]);
    else
        set(handles.help2,'ForegroundColor',[0.75 0.75 0.75]);
        set(handles.help3,'ForegroundColor','b');
    end
catch
     set(handles.e,'Visible','on');
end
end

%-------------------------------------------------------------------------%

function errorok_Callback(~,~,handles)

handles.e.Visible = 'off';
movegui(handles.e,'center');
end

%-------------------------------------------------------------------------%
%FUNCIONES PARA EL PROCESAMIENTO DE DATOS

function s = RespImp(s,f1,f2,T,t1)
%Calcula la respuesta al impulso de un archivo en el cual
%se utilizo el metodo sine sweep logaritmico
%s  = estuctura con mediciones
%f1 = frecuencia inicial (Hz)
%f2 = frecuencia final (Hz)
%T  = duración del sine sweep (seg)
%t1 = tiempo de silencio inicial (seg)

fs = s.fs;
[s.h,s.n] = structfun(@RI,s.med,'UniformOutput',0);

    function [h,n] = RI(y)
    y = y';                                 %transponer salida
    y = y(t1*fs+1:end);                     %recortar silencio inicial
    y = y(1:(T)*fs);                        %recortar tiempo extra
    %Generar sine sweep
    w1 = f1*2*pi; w2 = f2*2*pi;
    t = 0:1/fs:T;                           %definir vector tiempo
    K = T*w1/log(w2/w1);            
    L = T/log(w2/w1);
    x = sin(K*(exp(t/L)-1));                %vector sine sweep
    %Filtro inverso
    w = (K/L)*exp(t/L);
    m = w1./(2*pi*w);
    k = m.*fliplr(x);
    k = k/abs(max(k));
    k = k(1:end-1);
%     fill = zeros(1,5*fs);
%     k = [fill k];                           %rellena con 0 los 5 seg extra
    %Calcular h(t) (respuesta al impulso)
    K = fft(k); Y = fft(y);         
    H = Y.*K;
    h = ifft(H);
    h = h/max(abs(h));                       %normalizar h
    n = 1/fs:1/fs:length(h)/fs;
    end
    
end
%-------------------------------------------------------------------------%
function s = Cut(s)
%Recorta el primer segmento de la señal

fs = s.fs;
[s.h,s.n] = structfun(@Cutit,s.h,'UniformOutput',0);

    function [h,n] = Cutit(x)
        x = abs(x);
        [~,left] = max(x);
        h = x(left:end);
        n = 1/fs:1/fs:length(h)/fs;
    end
end
%-------------------------------------------------------------------------%
function s = Lundy(s)

fs = s.fs;
[s.h, s.cut, s.Ec, s.e] = structfun(@Lundit,s.h,'UniformOutput',0);

    function [h,cut,Ec,e] = Lundit(h)
    x = h;
    x = x.^2;       
    %Saco RMS del último 10% (asumido ruido)
    RMSdB = 10*log10(mean(x(round(0.9*length(x)):end))/max(x));
    %---------------------------------------------------------------------%
    %Señal Promediada por intervalos de 30ms
    ws = round(0.03*fs);
    d  = length(x);
    IL = floor(d/ws);
    X  = zeros(1,IL);
    NL = zeros(1,IL);   
        for i = 1:IL                        %Promedio por intervalos
            a = 1+ws*(i-1);
            b = ws*i;
            X(i)  = mean(x(a:b));
            NL(i) = ceil(ws/2)+ws*(i-1);
        end
    XdB = 10*log10(X/max(x));
    %---------------------------------------------------------------------%
    %Buscar indice +10dB por encima del piso piso de ruido%
    right = find(XdB(1:end)<RMSdB+10,1);
    right = right-1;
    if isempty(right)==1                    %Condición si intervalo corto
        right=10;
    elseif right<10
        right=10;
    end
    %---------------------------------------------------------------------%
    %Regresión lineal en el intervalo:(RMS+10db,RMS)%
    p = megafit(NL(1:right),XdB(1:right));     
    cross = (RMSdB-p(2))/p(1);              %Punto de cruce entre recta de
                                            %regresión lineal y recta RMS
    %---------------------------------------------------------------------%
    %Parte Iterativa!!!%
    e     = 1;      %e = error (error entre punto de cruce viejo y nuevo)
    it    = 1;      %it = numero de iteración
    while e>0.001 && it<=5
        P = 10;
        delta = abs(10/p(1));
        ws = floor(delta/P);
        IL = floor(length(x(1:round(cross-delta)))/ws);
        if IL < 2                       
            IL=2;                        
        elseif isempty(IL)==1
            IL=2;
        end
        X  = zeros(1,IL);
        NL = zeros(1,IL);
        for i = 1:IL
            a = 1+ws*(i-1);
            b = ws*i;
            X(i) = mean(x(a:b));
            NL(i) = ceil(ws/2)+ws*(i-1);
        end
        XdB = 10*log10(X/max(x));
        
        p = megafit(NL,XdB);
        noise = x(round(cross+delta):end);
        if length(noise) < round(0.1*length(x))
            noise = x(round(0.9*length(x)):end); 
        end       
        RMSdB = 10*log10(mean(noise)/max(x));
        e = abs((cross-(RMSdB-p(2))/p(1))/cross);
        cross = round((RMSdB-p(2))/p(1));
        it = it+1;
    end
    %---------------------------------------------------------------------%
    %Calculo de energia de compensación (Ec), corte en seg%
    Ec = max(x)*10^(p(2)/10)*...
        exp(p(1)/10/log10(exp(1))*cross)/(-p(1)/10/log10(exp(1)));
    cut = cross/fs;
    h = h(1:cross);
    
    end
end
%-------------------------------------------------------------------------%
function s = Filter(s)
%Filtros
%Guarda las diferentes bandas y mediciones en un formato
%s.oct1/3.bimj, donde i es el numero de banda y j el numero de medición.
%Ese formato se continua hasta la función Convert.

h = s.h;
fs = s.fs;
n = length(fieldnames(h));
    for j = 1:n
        x = h.(sprintf('m%d',j));
        oct1 = [31.62 63.1 125.89 251.19 501.19 ...
            1000 1995.26 3981.07 7943.28 15848.93];
            for i = 1:length(oct1)
                filter1 = fdesign.octave(1,'Class 0','N,F0',6,oct1(i),fs);
                filter1 = design(filter1,'Butter');
                s.oct1.(sprintf('b%dm%d',i,j)) = filter(filter1,x);
            end

        oct3 =[28.5 32 36 57 64 71.8 111.3 125 140.3 222.7 250 280.6 ...
            445.5 500 561 890.9 1000 1122.46 1781.79 2000 2244.92 ...
            3563.59 4000 4489.84 7127.19 8000 8979.7 14254.4 16000 17959.4];
            for i = 1:length(oct3)
                filter1 = fdesign.octave(3,'Class 0','N,F0',8,oct3(i),fs);
                filter1 = design(filter1,'Butter');
                s.oct3.(sprintf('b%dm%d',i,j)) = filter(filter1,x);
            end  
    end
end
%-------------------------------------------------------------------------%
function s = Smooth(s)
%Suaviza la señal con Hilbert (envolvente), y luego Schroeder (suavisado)

s.soft1 = structfun(@Criminal,s.oct1,'UniformOutput',0);
s.soft3 = structfun(@Criminal,s.oct3,'UniformOutput',0);

    function y = Criminal(x)
    b = abs(hilbert(x));
    y = cumsum(b.^2,'reverse');
    end
end
%-------------------------------------------------------------------------%
function s = DBFS(s)
%Pasa a dBFS

s.DB1 = structfun(@fullscale,s.soft1,'UniformOutput',0);
s.DB3 = structfun(@fullscale,s.soft3,'UniformOutput',0);

    function y = fullscale(x)
        y = 10*log10(x/max(x));
    end
end
%-------------------------------------------------------------------------%
function s = TR(s)


fs = s.fs;

[s.nEDT1, s.pEDT1, s.edt1, s.nT101, s.pT101, s.t101,...
    s.nT201, s.pT201, s.t201, s.nT301, s.pT301, s.t301] =...
    structfun(@TRc,s.DB1,'UniformOutput',0);
[s.nEDT3, s.pEDT3, s.edt3, s.nT103, s.pT103, s.t103,...
    s.nT203, s.pT203, s.t203, s.nT303, s.pT303, s.t303] =...
    structfun(@TRc,s.DB3,'UniformOutput',0);

    function [nEDT,pEDT,edt,nT10,pT10,t10,nT20,pT20,t20,nT30,pT30,t30] = TRc(x)

        noise = find(x<=-45,1,'first');
        q = isempty(noise);
        if q==0
            x = x(1:noise);
            n = 1/fs:1/fs:length(x)/fs;
        end
        
        %EDT
        sup = find(x==0,1,'first');
        low = find(x<=-10,1,'first');
        nEDT = n(sup:low);
        xEDT = x(sup:low);
        pEDT = megafit(nEDT,xEDT);
        edt = (-60-pEDT(2))/pEDT(1);
        
        %T10
        sup = find(x<=-5,1,'first');   
        low = find(x<=-15,1,'first');
        nT10 = n(sup:low);
        xT10 = x(sup:low);
        pT10 = megafit(nT10,xT10);
        t10 = (-60-pT10(2))/pT10(1);
        
        %T20
        sup = find(x<=-5,1,'first');   
        low = find(x<=-25,1,'first');
        nT20 = n(sup:low);
        xT20 = x(sup:low);
        pT20 = megafit(nT20,xT20);
        t20 = (-60-pT20(2))/pT20(1);
        
        %T30
        sup = find(x<=-5,1,'first');   
        low = find(x<=-35,1,'first');
        nT30 = n(sup:low);
        xT30 = x(sup:low);
        pT30 = megafit(nT30,xT30);
        t30 = (-60-pT30(2))/pT30(1);
        
    end
end
%-------------------------------------------------------------------------%
function v = Convert(s)
%Pasa de un formato s.(parametro/filtro).bimj donde están juntos el numero
%de banda y de medición a un formato v.(parametro/filtro).bi.mj donde
%todos los valores por banda de cada medición están agrupados dentro de
%sus bandas correspondientes.
%Principalmente hice esto para poder hacer los promedios, asi para obtener
%por ejemplo el promedio entre muestras del EDT de la primera banda en
%filtro de octavas solo digo que se promedien los contenidos de v.edt1.b1

n = length(fieldnames(s.med));

for i = 1:n
    for j = 1:10
        v.edt1.(sprintf('b%d',j)).(sprintf('m%d',i)) = s.edt1.(sprintf('b%dm%d',j,i));
        v.t101.(sprintf('b%d',j)).(sprintf('m%d',i)) = s.t101.(sprintf('b%dm%d',j,i));
        v.t201.(sprintf('b%d',j)).(sprintf('m%d',i)) = s.t201.(sprintf('b%dm%d',j,i));
        v.t301.(sprintf('b%d',j)).(sprintf('m%d',i)) = s.t301.(sprintf('b%dm%d',j,i));
    end
    for j = 1:30
        v.edt3.(sprintf('b%d',j)).(sprintf('m%d',i)) = s.edt3.(sprintf('b%dm%d',j,i));
        v.t103.(sprintf('b%d',j)).(sprintf('m%d',i)) = s.t103.(sprintf('b%dm%d',j,i));
        v.t203.(sprintf('b%d',j)).(sprintf('m%d',i)) = s.t203.(sprintf('b%dm%d',j,i));
        v.t303.(sprintf('b%d',j)).(sprintf('m%d',i)) = s.t303.(sprintf('b%dm%d',j,i));
    end
end
end
%-------------------------------------------------------------------------%
function v = Promedio(v)
%Calcula los promedios y los guarda con el formato
%v.(parametro/filtro).bi.avg, es decir,
%al lado de sus correspondientes mj.

    for i = 1:10
    V = struct2cell(v.edt1.(sprintf('b%d',i)));
    C = cat(1,V{:});
    v.edt1.(sprintf('b%d',i)).avg = mean(C);

    V = struct2cell(v.t101.(sprintf('b%d',i)));
    C = cat(1,V{:});
    v.t101.(sprintf('b%d',i)).avg = mean(C);

    V = struct2cell(v.t201.(sprintf('b%d',i)));
    C = cat(1,V{:});
    v.t201.(sprintf('b%d',i)).avg = mean(C);

    V = struct2cell(v.t301.(sprintf('b%d',i)));
    C = cat(1,V{:});
    v.t301.(sprintf('b%d',i)).avg = mean(C);
    end

    for i = 1:30
    V = struct2cell(v.edt3.(sprintf('b%d',i)));
    C = cat(1,V{:});
    v.edt3.(sprintf('b%d',i)).avg = mean(C);

    V = struct2cell(v.t103.(sprintf('b%d',i)));
    C = cat(1,V{:});
    v.t103.(sprintf('b%d',i)).avg = mean(C);

    V = struct2cell(v.t203.(sprintf('b%d',i)));
    C = cat(1,V{:});
    v.t203.(sprintf('b%d',i)).avg = mean(C);

    V = struct2cell(v.t303.(sprintf('b%d',i)));
    C = cat(1,V{:});
    v.t303.(sprintf('b%d',i)).avg = mean(C);
    end
end
%-------------------------------------------------------------------------%
function v = Tablatize(v)
%Organiza los descriptores (promedio) en dos matrices segun el tipo de filtro
%para que Julieta los pueda convertir en tabla

%Prealocación de espacio para mejor rendimiento
edt1 = zeros(10,1);
t101 = zeros(10,1);
t201 = zeros(10,1);
t301 = zeros(10,1);
edt3 = zeros(30,1);
t103 = zeros(30,1);
t203 = zeros(30,1);
t303 = zeros(30,1);

%Organizar los promedios de cada descriptor/tipo de filtro en arrays
for i = 1:10
    edt1(i)=v.edt1.(sprintf('b%d',i)).avg;
    t101(i)=v.t101.(sprintf('b%d',i)).avg;
    t201(i)=v.t201.(sprintf('b%d',i)).avg;
    t301(i)=v.t301.(sprintf('b%d',i)).avg;
end

for i = 1:30
    edt3(i)=v.edt3.(sprintf('b%d',i)).avg;
    t103(i)=v.t103.(sprintf('b%d',i)).avg;
    t203(i)=v.t203.(sprintf('b%d',i)).avg;
    t303(i)=v.t303.(sprintf('b%d',i)).avg;
end

%Concatenar en dos matrices segun tipo de filtro
TR1 = cat(2,edt1,t101,t201,t301);
TR3 = cat(2,edt3,t103,t203,t303);

%Transponer para que queden en matriz fila
v.Tabla1 = TR1';
v.Tabla3 = TR3';
end
%-------------------------------------------------------------------------%
function s = Plotter(s)

s.plotter1 = structfun(@plotit,s.oct1,'UniformOutput',0);
s.plotter3 = structfun(@plotit,s.oct3,'UniformOutput',0);

    function y = plotit(x)
        a = abs(hilbert(x));
        y = 20*log10(a/max(a));
    end
end
%-------------------------------------------------------------------------%
function p = megafit(n,x)
        N=length(n); %numero de elementos que contiene n
        I=ones(N,1);
        Z=[n(:) I(:)];
        c=Z'*Z;
        o=Z'*(x(:));
        p=c\o; %p(1)=pendiente p(2)=oo
        promedion=sum(n)/N;
        promediox=sum(x)/N;
        %calculo del error r=coeficiente de correlacion
        Snx=(sum(n.*x)/N)-(promedion*promediox);
        Sn=sqrt((sum(n.^2)/N)-(sum(n)/N)^2);
        Sx=sqrt((sum(x.^2)/N)-(sum(x)/N)^2);
        r=(Snx/(Sn*Sx));
        p(3) = r^2;   %porcentaje de exactitud de la regresion lineal
end
%-------------------------------------------------------------------------%
end