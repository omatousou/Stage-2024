function Anatoledisplayfig(x,y)
    % Filtrage médian pour atténuer les pics de bruit impulsionnel
    median_filtered_signal = medfilt1(y, 3); % Taille de la fenêtre médiane
    sig = (median_filtered_signal-min(median_filtered_signal))/max(median_filtered_signal-min(median_filtered_signal));
    % Affichage des graphiques
    figure;
    subplot(3,1,1);
    plot(x, y);
    title('Signal Original avec Bruit Impulsionnel');
    
    subplot(3,1,2);
    plot(x, sig);
    title('Signal après Filtrage Médian');
    
    a = fft(sig);
    a(100:1900)=0;
    b = ifft(a);
    
    subplot(3,1,3);
    scatter(x, sig,0.01,'.');
    hold on
    plot(x,abs(b),'Color', 'r', 'LineWidth', 1)
    
    title('Signal après Filtrage basses distances');
end