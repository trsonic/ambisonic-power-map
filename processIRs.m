close all
clear

addpath('externals/Spherical-Harmonic-Transform/')
addpath('externals/Higher-Order-Ambisonics/')


figdir = 'figures/';

initFolder(figdir)

%% load IRs
wavlist = dir("IRs/3_Output_IRs/**/*.wav");
% ii = [];
% for i = 1:numel(wavlist)
%     info = audioinfo([wavlist(i).folder '/' wavlist(i).name]);
% 
%     % look for 3OA responses
%     if info.NumChannels == 16
%         ii = [ii i];
%     end
% end

ii = [10561	10562	10563	10564	10565	10566	10567	10568	10569	10570	10571	10572	10573	10574	10575	10576	10577	10578	10579	10580	10581	10582	10583	10584	10585	10586	10587	10588	10589	10590	10591	10592	10593	10594	10595	10596	10597	10598	10599	10600	10601	10602	10603	10604	10605	10606	10607	10608	10609	10610	10611	10612	10613	10614	10615	10616	10617	10618	10619	10620	10621	10622	10623	10624	10625	10626	10627	10628	10629	10630	10631	10632	10633	10634	10635	10636	10637	10638	10639	10640	10641	10642	10643	10644	10645	10646	10647	10648	10649	10650	10651	10652	10653	10654	10655	10656	10657	10658	10659	10660	10661	10662	10663	10664	10665	10666	10667	10668	10669	10670	10671	10672	10673	10674	10675	10676	10677	10678	10679	10680	10681	10682	10683	10684	10685	10686	10687	10688	10689	10690	10691	10692	10693	10694	10695	10696	10697	10698	10699	10700	10701	10702	10703	10704	10705	10706	10707	10708	10709	10710	10711	10712	10713	10714	10715	10716	10717	10718	10719	10720	10721	10722	10723	10724	10725	10726	10727	10728	10729	10730	10731	10732	10733	10734	10735	10736	10737	10738	10739	10740	10741	10742	10743	10744	10745	10746	10747	10748	10749	10750	10751	10752	10753	10754	10755	10756	10757	10758	10759	10760	10761	10762	10763	10764	10765	10766	10767	10768	10769	10770	10771	10772	10773	10774	10775	10776	10777	10778	10779	10780	10781	10782	10783	10784	10785	10786	10787	10788	10789	10790	10791	10792	10793	10794	10795	10796	10797	10798	10799	10800	10801	10802	10803	10804	10805	10806	10807	10808	10809	10810	10811	10812	10813	10814	10815	10816	10817	10818	10819	10820	10821	10822	10823	10824	10825	10826	10827	10828	10829	10830	10831	10832	10833	10834	10835	10836	10837	10838	10839	10840	10841	10842	10843	10844	10845	10846	10847	10848	10849	10850	10851	10852	10853	10854	10855	10856	10857	10858	10859	10860	10861	10862	10863	10864	10865	10866	10867	10868	10869	10870	10871	10872	10873	10874	10875	10876	10877	10878	10879	10880	11079	11080	11081	11082	11083	11084];
wavlist = wavlist(ii);
parfor i = 1:numel(wavlist)
    [ySH, Fs] = audioread([wavlist(i).folder '/' wavlist(i).name]);
    name = wavlist(i).name;

    plotPowerMap(ySH,Fs,name,figdir);

end

%% 
function plotPowerMap(ySH,Fs,name,figdir)

    order = sqrt(size(ySH,2))-1;
    
    step = 5;
    az = -180:step:180;
    el = -90:step:90;
    az = az + randn(size(az))*0.01;
    el = el + randn(size(el))*0.01;
    az = min(max(az,-180),180);
    el = min(max(el,-90),90);
    
    for i = 1:length(az)
        for j = 1:length(el)
            Y = getRSH(order,[az(i) el(j)]);
            % convert from n3d to sn3d
            for m = 0:order
                idx_order = m^2 + (1:2*m+1);
                Y(idx_order, :) =  Y(idx_order, :) / sqrt(2*m+1);
            end
            LS =  ySH * Y;
            value(j,i) = 20*log10(rms(LS));
        end
    end
        
    %% plot
    figure
    axesm('MapProjection','mollweid','MapLatLimit',[-90 90],'Gcolor','black','GLineWidth',1.0,'MLineLocation',45,'PLineLocation',30); 
    axis off
    gridm('on')
    title(name,'Interpreter','none')
    
    % plot data
    s = pcolorm(el,az,value);
    s.EdgeColor = 'none';
    colormap(parula)
    c=colorbar('location','southoutside');
    c.Label.String='SPL (dB)';
    c.Label.FontSize=14;
    c.FontSize=14;

    % labels
    fsize = 12;
    fcolor = 'black';
    vertshift = -5;
    horishift = 5;
    textm(vertshift,horishift-135,'-135','color',fcolor,'fontsize',fsize);
    textm(vertshift,horishift-90,'-90','color',fcolor,'fontsize',fsize);
    textm(vertshift,horishift-45,'-45','color',fcolor,'fontsize',fsize);
    textm(vertshift,horishift+0,'0','color',fcolor,'fontsize',fsize);
    textm(vertshift,horishift+45,'45','color',fcolor,'fontsize',fsize);
    textm(vertshift,horishift+90,'90','color',fcolor,'fontsize',fsize);
    textm(vertshift,horishift+135,'135','color',fcolor,'fontsize',fsize);
    textm(vertshift-60,horishift+0,'-60','color',fcolor,'fontsize',fsize);
    textm(vertshift-30,horishift+0,'-30','color',fcolor,'fontsize',fsize);
    textm(vertshift+30,horishift+0,'30','color',fcolor,'fontsize',fsize);
    textm(vertshift+60,horishift+0,'60','color',fcolor,'fontsize',fsize);

    % save figure
    figlen = 6;
    width = 4*figlen;
    height = 3*figlen;
    set(gcf,'PaperPosition',[0 0 width height],'PaperSize',[width height]);
    saveas(gcf,[ figdir name '.png'])
    close

end
