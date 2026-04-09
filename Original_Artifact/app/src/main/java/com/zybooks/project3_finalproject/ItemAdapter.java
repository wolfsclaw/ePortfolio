package com.zybooks.project3_finalproject;

import android.transition.AutoTransition;
import android.transition.TransitionManager;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageButton;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.constraintlayout.widget.ConstraintLayout;
import androidx.recyclerview.widget.RecyclerView;

import com.google.android.material.card.MaterialCardView;

import java.util.List;

public class ItemAdapter extends RecyclerView.Adapter<ItemAdapter.ItemVH> {
    private static final String TAG = "ItemAdapter";
    List<Item> itemList;

    public ItemAdapter(List<Item> itemList) {this.itemList = itemList;}

    @NonNull
    @Override
    public ItemVH onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        View view = LayoutInflater.from(parent.getContext()).inflate(R.layout.inventory_item, parent, false);
        return new ItemVH(view);
    }

    @Override
    public void onBindViewHolder(@NonNull ItemVH holder, int position) {
        Item item = itemList.get(position);
        holder.titleTextView.setText(item.getTitle());
        holder.quantityTextView.setText(item.getQuantity());
        holder.quantityUnitsTextView.setText(item.getQuantityUnits());

        boolean isExpanded = itemList.get(position).isExpanded();
        holder.itemCardActions.setVisibility(isExpanded ? View.VISIBLE : View.GONE);
    }

    @Override
    public int getItemCount() {
        return itemList.size();
    }

    class ItemVH extends RecyclerView.ViewHolder {
        private static final String TAG = "ItemVH";

        TextView titleTextView, quantityTextView, quantityUnitsTextView;
        ConstraintLayout cardHeader, itemCardActions;
        ImageButton arrowButton;
        MaterialCardView cardView;

        public ItemVH(@NonNull final View itemView) {
            super(itemView);

            cardHeader = itemView.findViewById(R.id.itemCardHeader);
            arrowButton = itemView.findViewById(R.id.arrowButton);
            titleTextView = itemView.findViewById(R.id.itemTitle);
            quantityTextView = itemView.findViewById(R.id.itemQuantity);
            quantityUnitsTextView = itemView.findViewById(R.id.itemQuantityUnits);

            cardView = itemView.findViewById(R.id.card);
            itemCardActions = itemView.findViewById(R.id.itemCardActions);

            cardHeader.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    //Item item = itemList.get(getAdapterPosition());
                    if (itemCardActions.getVisibility()==View.GONE) {
                        TransitionManager.beginDelayedTransition((ViewGroup) cardView.getParent().getParent(), new AutoTransition());
                        itemCardActions.setVisibility(View.VISIBLE);
                        arrowButton.setImageResource(R.drawable.ic_baseline_arrow_up_24);
                    } else {
                        TransitionManager.beginDelayedTransition((ViewGroup) cardView.getParent().getParent(), new AutoTransition());
                        itemCardActions.setVisibility(View.GONE);
                        arrowButton.setImageResource(R.drawable.ic_baseline_arrow_down_24);
                    }
                }
            });

            arrowButton.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    //Item item = itemList.get(getAdapterPosition());
                    if (itemCardActions.getVisibility()==View.GONE) {
                        TransitionManager.beginDelayedTransition((ViewGroup) cardView.getParent().getParent(), new AutoTransition());
                        itemCardActions.setVisibility(View.VISIBLE);
                        arrowButton.setImageResource(R.drawable.ic_baseline_arrow_up_24);
                    } else {
                        TransitionManager.beginDelayedTransition((ViewGroup) cardView.getParent().getParent(), new AutoTransition());
                        itemCardActions.setVisibility(View.GONE);
                        arrowButton.setImageResource(R.drawable.ic_baseline_arrow_down_24);
                    }
                }
            });
        }
    }
}

