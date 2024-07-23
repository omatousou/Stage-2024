o = 1;
for l = 1:3
for n = 1:3
    L= 10;
    lisx= [];
    lisy= [];
    for i=0:500000
        x = rand()*10;
        y = rand()*10;
        probtirx = rand();
        probtiry = rand();
        probtirz = rand();
        dPx = 2/L*sin(n*pi*x/L)^2;
        dPy = 2/L*sin(l*pi*y/L)^2;
        if probtirx<=dPx
             lisx(end+1) = x;
        end
        if probtiry<=dPy
             lisy(end+1) = y;
        end
    end
    en = min([length(lisx),length(lisy)]);
    subplot(3,3,o)
    o =o+1;
    scatter(lisx(1:en),lisy(1:en),'MarkerEdgeColor','k',...
            'MarkerFaceColor',[0 .75 .75],'MarkerFaceAlpha', 0.1,'MarkerEdgeAlpha',0.1)
    hold on
    plot([0,L,L,0,0],[0,0,L,L,0],'r')
    title(sprintf('n = %d, l = %d', n, l));
    axis equal
    xlabel('x')
    ylabel('y')
    hold off
end
end

