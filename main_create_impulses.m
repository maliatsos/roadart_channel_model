% script created by Kostas Maliatsos for UPRC
% current version 02/12/2017

num_channels = 1;

TxParams.num_elements = TxParams.sizes_x*TxParams.sizes_y;
RxParams.num_elements = RxParams.sizes_x*RxParams.sizes_y;
delay_axis = 0:1/linkParams.bandwidth:(linkParams.frequency_bins/2-1)/linkParams.bandwidth;
num_elements_tx = TxParams.sizes_x*TxParams.sizes_y;
num_elements_rx = RxParams.sizes_x*RxParams.sizes_y;

% all_channels = zeros(num_channels, num_elements_rx, num_elements_tx, length(delay_axis), linkParams.stationarity_snapshots);
TotalChannels = zeros(num_channels, num_elements_rx, num_elements_tx, linkParams.frequency_bins, linkParams.stationarity_snapshots);
all_measurement = zeros(num_channels, num_elements_rx*num_elements_tx*linkParams.frequency_bins*linkParams.stationarity_snapshots);
ideal_parameters = struct('delays', [], 'dopplers', [], 'phi_aoas', [], 'phi_aods', [], 'theta_aoas', [], 'theta_aods', [], 'path_gains', []);
counter = 1;
for kk = 25002 : 25002 %linkParams.stationarity_snapshots:length(results)
% for kk = 1 : linkParams.stationarity_snapshots:length(results)
    
    %% Channel creation:
    channel = zeros(num_elements_rx, num_elements_tx, length(delay_axis), linkParams.stationarity_snapshots);
    Channel = zeros(size(channel,1), size(channel,2), linkParams.frequency_bins, linkParams.stationarity_snapshots);
    
    for mm = 0 : linkParams.stationarity_snapshots-1
        t = linkParams.time_axis(kk+mm:kk+mm+linkParams.stationarity_snapshots-1)-linkParams.time_axis(kk);
        
        %% Phi s:
        phi_aods = [results(kk+mm).static_phi_aods; results(kk+mm).sign_phi_aods;...
            results(kk+mm).bridge_phi_aods; results(kk+mm).v2v_phi_aods];
        phi_aoas = [results(kk+mm).static_phi_aoas; results(kk+mm).sign_phi_aoas;...
            results(kk+mm).bridge_phi_aoas; results(kk+mm).v2v_phi_aoas];
        ideal_parameters(counter+mm).phi_aods = phi_aods;
        ideal_parameters(counter+mm).phi_aoas = phi_aoas;
        %% Thetas:
        theta_aods = [results(kk+mm).static_theta_aods; results(kk+mm).sign_theta_aods;...
            results(kk+mm).bridge_theta_aods; results(kk+mm).v2v_theta_aods]+pi/2;
        theta_aoas = [results(kk+mm).static_theta_aoas; results(kk+mm).sign_theta_aoas;...
            results(kk+mm).bridge_theta_aoas; results(kk+mm).v2v_theta_aoas] +pi/2;
        ideal_parameters(counter+mm).theta_aoas = theta_aoas;
        ideal_parameters(counter+mm).theta_aods = theta_aods;
        
        [Btx, Brx] = calculate_patterns(TxParams, RxParams, phi_aods, theta_aods, phi_aoas, theta_aoas);
        
        %% Dopplers:
        dopplers = [results(kk+mm).doppler_static; results(kk+mm).doppler_signs;...
            results(kk+mm).doppler_bridges; results(kk+mm).doppler_v2v];
%         dopplers = zeros(length(ideal_parameters(counter+mm).theta_aoas),1);
        ideal_parameters(counter + mm).dopplers = dopplers;
        
        %% Delays:
        delays = [results(kk+mm).static_delays; results(kk+mm).sign_delays;...
            results(kk+mm).bridge_delays; results(kk+mm).v2v_delays];
        delays = delays - results(kk+mm).TxRx_distance/c;
        delays = floor(delays*linkParams.bandwidth);
        ideal_parameters(counter + mm).delays = delays;
        
        path_gains = [results(kk+mm).path_gains_buildings; results(kk+mm).path_gains_signs;...
            results(kk+mm).path_gains_bridges; results(kk+mm).path_gains_v2v];
%         path_gains = path_gains.*sqrt(10.^([33-results(kk+mm).pathlosses_buildings; 36-results(kk+mm).pathlosses_signs;...
%             33-results(kk+mm).pathlosses_bridges; 36-results(kk+mm).pathlosses_v2v]/10));
%         total_power = sum(abs(path_gains).^2);
%         path_gains = path_gains/sqrt(total_power);
        ideal_parameters(counter+mm).path_gains = path_gains;
        
        %% Create Channel:
        for nn = 0 : max(delays)
            ind = find(delays == nn);
            Btx_tmp = squeeze(Btx(:,ind));
            Brx_tmp = squeeze(Brx(:,ind));
            gains_tmp = diag(path_gains(ind).*exp(1j*2*pi*dopplers(ind)*t(mm+1)));
            H = Brx_tmp*gains_tmp*Btx_tmp.';
            channel(:,:,nn+1, mm+1) = H;
        end
        for ll = 1 : size(channel,1)
            for ii = 1 : size(channel, 2)
                tmp = squeeze(channel(ll, ii, :, mm+1));
                Channel(ll, ii, :, mm+1) = fftshift(fft(tmp, linkParams.frequency_bins));
            end
        end
    end
    [X_dmc, R] = create_only_dmc_channel(linkParams, TxParams, RxParams, dmc_parameters);
    X_dmc = X_dmc.' + sqrt(dmc_parameters.alpha_0/2)*(randn(size(X_dmc,2), size(X_dmc,1)) + 1i*randn(size(X_dmc,2), size(X_dmc,1)));
    
    %% Total Channel:
    for mm = 1 : RxParams.num_elements
        for ll = 1 : TxParams.num_elements
            for nn = 1 : linkParams.stationarity_snapshots
                TotalChannels(counter, mm, ll, :, nn) = squeeze(Channel(mm, ll, :, nn)) + X_dmc(:,(mm-1)*TxParams.num_elements*linkParams.stationarity_snapshots + (mm-1)*linkParams.stationarity_snapshots + nn);
            end
        end
    end
    
    Channel = squeeze(TotalChannels(counter,:,:,:,:));
    measurement = permute(Channel, [4 3 2 1]);
    measurement = measurement(:);
    all_measurement(counter,:) = measurement;
    if counter == num_channels
        break
    end
    counter = counter + 1;
end