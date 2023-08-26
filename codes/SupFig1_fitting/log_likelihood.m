function ll_Q = log_likelihood(x,history,type)

tr = 1;
pull = history.success;

switch type 
    case 'RNLDF' % S-F
        [~,~,action] = Q_learning(history,tr,x(5),x(6),x(1),x(2),x(4),0,x(3));
    case 'RCNLDF' % P-S-F
        [~,~,action] = Q_learning(history,tr,x(6),x(7),x(1),x(2),x(5),x(4),x(3));
end

ll = pull .* log(action) + (1-pull) .* log(1-action);

ll_Q = -nansum(ll);
end
