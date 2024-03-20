function animateGndTr(long,lat, gndPt, gndTrFig, tScale, T, te, omega, loop)
%ANIMATEGNDTR Summary of this function goes here
%   Detailed explanation goes here
tAct = 0;
loops = 0;
long = rmmissing(long); lat = rmmissing(lat);
while(1)
    [~,i] = min(abs(T-tAct));
    tic;
    addpoints(gndPt, long(i),lat(i)); drawnow();  pause(0.05);
    subtitle(gca(gndTrFig), "T: "+string(duration(0,0,tAct+loops*max(T)))+",   Lat: "+round(lat(i,:)*1000)/1000+"$$^\circ$$,   Long: "+round(long(i,:)*1000)/1000+"$$^\circ$$", Interpreter="latex");
    dt = toc*tScale;    tAct = tAct + dt;

%% End-of-propagation behavior
    if tAct >= T(end)
        % If either we don't loop or there's an impact
        if(~isempty(te) || ~loop)
            subtitle(gca(gndTrFig), "T: "+string(duration(0,0,T(end)+loops*max(T)))+",   Lat: "+round(lat(end,:)*1000)/1000+"$$^\circ$$,   Long: "+round(long(end,:)*1000)/1000+"$$^\circ$$", Interpreter="latex");
            addpoints(gndPt, long(end),lat(end)); drawnow();
            break
        end

        % add another period of ground track
        [long, lat] = wrapLongLat(long-T(end)*omega, lat, 30);
        plot(long,lat, '-r');
        long = rmmissing(long); lat = rmmissing(lat);

        tAct = 0; loops = loops+1;
    end
end
end
