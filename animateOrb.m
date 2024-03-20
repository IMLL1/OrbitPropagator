function animateOrb(Xeci, Veci, orbPt, orbFig, tScale, T, te, planet, omega, loop)
%ANIMATEORB Summary of this function goes here
%   Detailed explanation goes here
tAct = 0;
loops = 0;
dt = 0;
while(1)
    [~,i] = min(abs(T-tAct));
    tic;
    rotate(planet, [0;0;1], dt * omega, [0;0;0]);
    addpoints(orbPt, Xeci(i,1),Xeci(i,2),Xeci(i,3)); drawnow();  pause(0.05);
    subtitle(gca(orbFig), "T: "+string(duration(0,0,tAct+loops*max(T)))+",   $$r=$$"+round(norm(Xeci(i,:)/1000))+"km,   $$v=$$"+round(norm(Veci(i,:)))+"m/s", Interpreter="latex");
    dt = toc*tScale;    tAct = tAct + dt;

%% End-of-propagation behavior
    if tAct >= T(end)
        % If either we don't loop or there's an impact
        if(~isempty(te) || ~loop)
            subtitle(gca(orbFig), "T: "+string(duration(0,0,T(end)+loops*max(T)))+",   $$r=$$"+round(norm(Xeci(end,:)/1000))+"km,   $$v=$$"+round(norm(Veci(end,:)))+"m/s", Interpreter="latex");
            rotate(planet, [0;0;1], (T(end)-tAct+dt) * omega, [0;0;0]);
            addpoints(orbPt, Xeci(end,1),Xeci(end,2),Xeci(end,3));
            break
        end

        % add another period of ground track
        tAct = 0; loops = loops+1;
    end
end
end

